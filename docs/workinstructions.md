---
---

{% for instruction in site.data.work_instructions %}
{% if forloop.first %}

<table border=1>
<thead>
<tr>
<th>Instruction Set ID</th>
<th>Instruction Set Title</th>
<th>Step ID</th>
<th>Instruction</th>
<th>Tools Required</th>
<th>Materials Required</th>
<th>Estimated Time</th>
<th>Precautions</th>
<th>Quality Checks</th>
</tr>
</thead>
<tbody>
{% endif %}
<tr>
<td>{{ instruction.InstructionSetID }}</td>
<td>{{ instruction.InstructionSetTitle }}</td>
<td>{{ instruction.StepID }}</td>
<td>{{ instruction.Instruction }}</td>
<td>{{ instruction.ToolsRequired }}</td>
<td>{{ instruction.MaterialsRequired }}</td>
<td>{{ instruction.EstimatedTime }}</td>
<td>{{ instruction.Precautions }}</td>
<td>{{ instruction.QualityChecks }}</td>
</tr>
{% if forloop.last %}
</tbody>
</table>
{% endif %}
{% endfor %}
