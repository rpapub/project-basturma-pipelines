---
title: "Blog Posts Listing"
permalink: /blog/posts.html
---

<ul>
{% for post in site.posts %}
  <li>
    <a href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a><br />
    <p>{{ post.excerpt }}</p>
  </li>
{% endfor %}
</ul>
