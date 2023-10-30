'''
UiPath Workflow Analyzer to SonarQube Converter

This script converts the results from the UiPath Workflow Analyzer into the
Generic Issue Import Format accepted by SonarQube.

Prerequisites:
- Requires the output from UiPath's Workflow Analyzer in JSON format.

How to obtain uipath-workflow-analyzer_results.json:
- Use the UiPath CLI tool with the following command:
  uipcli.exe package analyze ./BlankProcess/project.json --resultPath path/to/uipath-workflow-analyzer_results.json
- Import with the following command:
   sonar-scanner.bat -D"sonar.projectKey=yourkey42" -D"sonar.sources=." -D"sonar.host.url=http://your-sonar-url:9000" -D"sonar.login=sqp_foobar4782f7305137b0279b38e887e4e2foobar" -Dsonar.externalIssuesReportPaths=path/to/sonarqube_input.json

Todo:
- needs more error handling in case of null values

Author: Christian Prior-Mamulyan (cprior@gmail.com)
Repository Location: https://github.com/rpapub/project-basturma-pipelines
LICENSE: CC-BY
'''

import json

# Load UiPath Workflow Analyzer results
with open('uipath-workflow-analyzer_results.json', 'r', encoding='utf-8') as f:
    uipath_results = json.load(f)

sonarqube_results = []

severity_mapping = {
    4: 'BLOCKER',
    3: 'CRITICAL',
    2: 'MAJOR'
}

for result in uipath_results:
    issue = {}
    issue['engineId'] = 'uipath-workflow-analyzer'
    issue['ruleId'] = result['ErrorCode']
    issue['type'] = 'CODE_SMELL'  # default, can be adjusted based on your needs
    issue['severity'] = severity_mapping.get(result['ErrorSeverity'], 'MINOR')
    issue['primaryLocation'] = {
        'message': result['Description'],
        'filePath': result['FilePath'] if result['FilePath'] else 'unknown_path'
    }
    # Add recommendation as additional info if available
    if 'Recommendation' in result and result['Recommendation'] is not None:
        issue['primaryLocation']['message'] += " Recommendation: " + result['Recommendation']
    sonarqube_results.append(issue)

# Wrap the array in a JSON object
output_data = {
    "issues": sonarqube_results
}

# Save the results in Generic Issue Import Format
with open('sonarqube_input.json', 'w', encoding='utf-8') as f:
    json.dump(output_data, f, indent=4)
