---
title: "Cloudflare tunnels for the homelab: bot fight mode, Home Assistant and OctoPrint"
description: ""
layout: post
comments: true
hide: false
tags: [blog, homelab]
---

I'm still amazed by the doors my domain purchase on Cloudflare opened.
With Cloudflare tunnels, it is possible to expose local sites to the internet without port forwarding.
This allows to map a subdomain of yours to a local `address:port`.
You access the subdomain via `https` which encrypts the connection between you and Cloudflare.
However, it seems like Cloudflare is decrypting the data before encrypting it again with the tunnel to your home lab.
If you have super sensitive data and don't trust Cloudflare, this might be a problem.

# Setup
The tunnel connects to my home lab via the Home Assistant [Cloudflared add-on](https://github.com/brenner-tobias/addon-cloudflared).
This add-on has a [wiki page](https://github.com/brenner-tobias/addon-cloudflared/wiki) which explains the setup from end-to-end.

I chose to manage the tunnel in Cloudflare which is called `remote managed tunnels` in the wiki.
This is probably a little bit more work, but I wanted to see how exactly the tunnels are configured in Cloudflare.
Since I bought my domain on Cloudflare, the subdomain was automatically added to the DNS records.
For the address of the local service, both, the IP and a `hostname.local` work in my case.

# Security
Since my DNS is managed by Cloudflare, I could also use their security features.
Go to `websites -> select domain -> security` and you will be presented with a list of security features.\
`WAF` is probably the most important one, where you can block certain countries, and challenge or block threats as classified by the Cloudflare machine learning model.\
`Bots` allows you to enable *Bot Fight Mode* which will block bad bots from accessing your site.
In the greater picture, this might reduce internet traffic and save some energy if bots are less incentivized to scrape the web.

# Fixing Bot Fight Mode issues
After enabling *Bot Fight Mode*, I noticed issues in Home Assistant and OctoPrint.
* For **Home Assistant**, the Google Assistant setup stopped working. Well, the assistant is some kind of bot, I guess? I had to add a WAF rule under `Tools -> IP access rules` to allow the Google ASN `AS15169`.
* For **OctoPrint**, the UI could not be loaded anymore. This can be fixed by adding the following in `.octoprint/config.yaml`.
```yaml
api:
  allowcrossorigin: true
```

# Conclusion
I can access my home lab on the go now!
Security should be better than opening ports on the router.