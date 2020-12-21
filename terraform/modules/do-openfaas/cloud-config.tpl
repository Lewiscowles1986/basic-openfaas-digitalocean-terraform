#cloud-config
ssh_authorized_keys:
  - ${ssh_key}

write_files:
- content: |
    server {
        listen  80;
        listen  [::]:80;
        server_name ${faasd_domain_name};
        root /var/www/html;
        index index.html index.htm;
        if ($ssl_protocol = "") {
           rewrite ^   https://${faasd_domain_name}$request_uri? permanent;
        }
    }
    server {
      listen  443 ssl http2;
      listen  [::]:443 ssl http2;
      server_name ${faasd_domain_name};
      ssl_certificate /etc/letsencrypt/live/${faasd_domain_name}/fullchain.pem;
      ssl_certificate_key /etc/letsencrypt/live/${faasd_domain_name}/privkey.pem;
      ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
      ssl_ciphers "ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA:DES-CBC3-SHA:HIGH:!aNULL:!eNULL:!EXPORT:!DES:!MD5:!PSK:!RC4";
      ssl_session_cache shared:SSL:10m;
      ssl_stapling on;
      ssl_stapling_verify on;
      # ssl_dhparam /etc/ssl/dhparam.pem;
      resolver 8.8.4.4 8.8.8.8 valid=300s;
      resolver_timeout 10s;
      ssl_prefer_server_ciphers on;
      add_header Strict-Transport-Security max-age=63072000;
      add_header X-Content-Type-Options nosniff;
      
      location / {
        proxy_set_header    X-Real-IP $remote_addr;
        proxy_set_header    Host      $http_host;
        proxy_pass http://localhost:8080;
      }
    }

  path: /etc/nginx/sites-available/faasd
- content: |
    dns_digitalocean_token = ${do_token}

  path: /etc/digitalocean-key
  permissions: "0600"

package_update: true

packages:
 - runc

runcmd:
- curl -sLSf https://github.com/containerd/containerd/releases/download/v1.3.5/containerd-1.3.5-linux-amd64.tar.gz > /tmp/containerd.tar.gz && tar -xvf /tmp/containerd.tar.gz -C /usr/local/bin/ --strip-components=1
- curl -SLfs https://raw.githubusercontent.com/containerd/containerd/v1.3.5/containerd.service | tee /etc/systemd/system/containerd.service
- systemctl daemon-reload && systemctl start containerd
- /sbin/sysctl -w net.ipv4.conf.all.forwarding=1
- mkdir -p /opt/cni/bin
- curl -sSL https://github.com/containernetworking/plugins/releases/download/v0.8.5/cni-plugins-linux-amd64-v0.8.5.tgz | tar -xz -C /opt/cni/bin
- mkdir -p /go/src/github.com/openfaas/
- mkdir -p /var/lib/faasd/secrets/
- echo ${gw_password} > /var/lib/faasd/secrets/basic-auth-password
- echo admin > /var/lib/faasd/secrets/basic-auth-user
- cd /go/src/github.com/openfaas/ && git clone --depth 1 --branch 0.9.10 https://github.com/openfaas/faasd
- curl -fSLs "https://github.com/openfaas/faasd/releases/download/0.9.10/faasd" --output "/usr/local/bin/faasd" && chmod a+x "/usr/local/bin/faasd"
- cd /go/src/github.com/openfaas/faasd/ && /usr/local/bin/faasd install
- systemctl status -l containerd --no-pager
- journalctl -u faasd-provider --no-pager
- systemctl status -l faasd-provider --no-pager
- systemctl status -l faasd --no-pager
- curl -sSLf https://cli.openfaas.com | sh
- sleep 5 && journalctl -u faasd --no-pager
- systemctl daemon-reload
- apt-get install -yqq nginx-full certbot python3-certbot-dns-digitalocean
- certbot certonly  --dns-digitalocean --dns-digitalocean-credentials /etc/digitalocean-key --dns-digitalocean-propagation-seconds 60 -d ${faasd_domain_name} -m ${letsencrypt_email} --agree-tos --no-eff-email --renew-by-default
- ln -s /etc/nginx/sites-available/faasd /etc/nginx/sites-enabled/faasd
- service nginx reload
