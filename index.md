---
layout: default
title: Index
---
Welcome to my website / blog.

# About Me
<div style="display: flex; width: 100%;">
  <div style="flex: 0 0 150px; margin-right: 20px;">
    <img src="{{ site.baseurl }}/images/tim.jpg" alt="That's me smiling at you" width="200"/>
  </div>
  <div style="flex: 1;">
    {% capture markdown_content %}
> **Contact**
> 
> [E-Mail](mailto:hello@redick.cc)\
> [fosstodon/@tuebel](https://fosstodon.org/@tuebel)\
> [X/@TimUebelhoer](https://x.com/TimUebelhoer), sporadic\
> [LinkedIn/tim-uebelhoer](https://www.linkedin.com/in/tim-uebelhoer/), sporadic
    {% endcapture %}
    {{ markdown_content | markdownify }}
  </div>
</div>

Formerly known as Tim Übelhör (Uebelhoer), I got married to a Redick, I am a father of two, a coder, maker and robotics nerd.\
Besides the nerdy technical hobbies, I like playing my guitar and piano, hiking, skiing and running.

From 2013-2018, I studied mechanical (B.Sc.) and automation engineering (M.Sc.) at RWTH Aachen University.\
From 2018-2024, I worked on my [thesis](https://doi.org/10.18154/RWTH-2024-04533) for my Dr.-Ing. (Germand Ph.D. in engineering) at the Institute of Automatic Control (RWTH Aachen University).\
Currently, I am a postdoc at the same institute.

# Latest Posts

<ul>
    {% for post in site.posts %}
    <li>
        <h2><a href="{{ post.url | relative_url }}">{{ post.title }}</a></h2>
        <p>{{ post.date | date: "%B %d, %Y" }}</p>
        <p>{{ post.excerpt | strip_html | truncatewords: 50 }}</p>
    </li>
    {% endfor %}
</ul>

<a rel="me" href="https://fosstodon.org/@tuebel">Mastodon</a>
