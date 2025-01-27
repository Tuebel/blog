---
title: "How I built my web presence"
description: "Some technical details on my current setup"
layout: post
comments: true
hide: false
categories: [Blog]
---

At the core of my independent web presence is the domain name **redick.cc**.
As long as I keep paying for the domain, I can move any service to another provider while the user-facing address doesn't change.
When researching for a good domain name registrar, *Namecheap* and *Cloudflare* often came up in forums.
To be honest, many registrars look like a giant add page trying to hide the long-term cost.
*Cloudflare* requires a registration before scanning for availability and has a much more basic design, which makes it seem more trustworthy.
Later I found out that Cloudflare also offers nice additional services like mail forwarding, mail obfuscation, and fast site hosting.

When searching for an available name, I had three priorities, It should...
1. cost about 10€ per year. Top-level domains in this price range include *.net*, *.org*, *.cc*, or *.xyz*. After all, it is a private domain and not a commercial endeavor. 
2. consist only of my last name. This allows me to offer *name@redick* mailboxes or *name.redick.cc* subdomain websites to my family.
3. should use a neutral top-level domain and somewhat known. For example, I am not an *.vip*.

My favorites were *redick.cc* and *redick.dev*.
Yes, I develop a lot of stuff, so *.dev* sounded nice.
But *redick.cc* is a bit easier and shorter to say to someone on the phone (at least in Germany).
Moreover, I knew *arduino.cc* and *dict.cc* so it did not seem too exotic.

## Website
As written in [why I built this website](/_posts/2024-10-23-why-I-built-this-website.md), I want to own my posts.
Moreover, I like the simplicity and portability of Markdown.
Therefore, I use Jekyll as a static site generator, as I currently do not plan to include any dynamic interactions.
My blog should only be a collection of posts.
Interactions are currently outsourced to the social web, where I link to these posts.

GitHub hosts the code of the website, and initially also was responsible for the deployment via actions.
When I bought the *redick.cc* domain, it was fairly simple to use this instead of the *tuebel.github.io* site.
However, I noticed that Cloudflare also allows hosting a Jekyll site.
A wonderful feature is the automatic mail obfuscation on the hosted page, so web crawlers are unable to extract my mail from the `mailto:` in my contact section.

## Mail
First, I used the email forwarding feature of Cloudflare to pass all mails to my personal Gmail account.
But getting an answer from an entirely different mail address is probably confusing to most people.
I would have loved to use a privacy-focused mail provider like *Proton*.
Unfortunately, most options were too pricey for multiple mail addresses, which are used very sporadically.

I settled with *Zoho mail* which is free for up to 5 users, supports custom domains, a reasonable number of aliases.
They store the mails encrypted at rest on European servers, which is good enough for me at the moment.
Since it is a business-focused product, it feels a bit clunky and overkill for family use. 
The business focus seems to be the only obvious catch: Offer the service for free and later sell the whole office suite when people get used to it.
Also, I noticed that my mails would get rejected when testing with my RWTH mail address.
Sending test mails to my Gmail and the live mailboxes works fine.