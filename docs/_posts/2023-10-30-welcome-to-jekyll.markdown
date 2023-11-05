---
layout: post
title: "Welcome to Jekyll!"
date: 2023-10-30 16:03:07 +0100
categories: jekyll update
---

You’ll find this post in your `_posts` directory. Go ahead and edit it and re-build the site to see your changes. You can rebuild the site in many different ways, but the most common way is to run `jekyll serve`, which launches a web server and auto-regenerates your site when a file is updated.

{% for category in site.categories %}
{{ category[0] }}
{% endfor %}

{% include bom.html parents="Server 1" %}

{{ site.data.site_info.missionstatement.text }}

## BOM

{% include bom.html parents="Switch 1" %}
{% include bom.html parents="Raspberry Pi Board" %}

## Requirements

{% include requirements.html doc_refs="foo" %}

<p>
  {{ site.data.site_info.announcement.message }}
  <a href="{{ site.data.site_info.announcement.link }}">{{ site.data.site_info.announcement.link_text }}</a>
</p>

![]({{ site.baseurl}}/docs/assets/images/visual-identity/cprima_pipelines_valves_nodes_fe463353-c3ea-484c-a68c-21ad1189e24e.png){:class="resize"}

{% include checklist.html checklistnames="Sample Checklist" heading="h3" %}

Jekyll requires blog post files to be named according to the following format:

`YEAR-MONTH-DAY-title.MARKUP`

Where `YEAR` is a four-digit number, `MONTH` and `DAY` are both two-digit numbers, and `MARKUP` is the file extension representing the format used in the file. After that, include the necessary front matter. Take a look at the source for this post to get an idea about how it works.

Jekyll also offers powerful support for code snippets:

{% highlight ruby %}
def print_hi(name)
puts "Hi, #{name}"
end
print_hi('Tom')
#=> prints 'Hi, Tom' to STDOUT.
{% endhighlight %}

Check out the [Jekyll docs][jekyll-docs] for more info on how to get the most out of Jekyll. File all bugs/feature requests at [Jekyll’s GitHub repo][jekyll-gh]. If you have questions, you can ask them on [Jekyll Talk][jekyll-talk].

[jekyll-docs]: https://jekyllrb.com/docs/home
[jekyll-gh]: https://github.com/jekyll/jekyll
[jekyll-talk]: https://talk.jekyllrb.com/

{% assign csv_data = site.data.technology-components-physical %}

<table class="checklist">
  <thead>
    <tr>
      <th>id</th>
      <th>category</th>
      <th>name</th>
      <th>description</th>
      <th>vendor</th>
      <th>version</th>
      <th>source</th>
      <th>productname</th>
      <th>platform</th>
      <th>licence</th>
      <th>created_at</th>
      <th>reviewed_at</th>
      <th>retired_at</th>
      <th>path</th>
      <th>visibility</th>
      <th>nickname</th>
    </tr>
  </thead>
  <tbody>
    {% for row in csv_data %}
    <tr>
      <td>{{ row.id }}</td>
      <td>{{ row.category }}</td>
      <td>{{ row.name }}</td>
      <td>{{ row.description }}</td>
      <td>{{ row.vendor }}</td>
      <td>{{ row.version }}</td>
      <td>{{ row.source }}</td>
      <td>{{ row.productname }}</td>
      <td>{{ row.platform }}</td>
      <td>{{ row.licence }}</td>
      <td>{{ row.created_at }}</td>
      <td>{{ row.reviewed_at }}</td>
      <td>{{ row.retired_at }}</td>
      <td>{{ row.path }}</td>
      <td>{{ row.visibility }}</td>
      <td>{{ row.nickname }}</td>
    </tr>
    {% endfor %}
  </tbody>
</table>
