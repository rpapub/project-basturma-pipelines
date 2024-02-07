---
title: "Outline"
---

## 0.1 Foreword - chapter
# 1 homelab - part
### 1.0.1 motivation - Section
when in Rhsn without access to Jenkins node: standstill

### 1.0.2 Incremental Homelab Iterations - Section
#### 1.0.2.1 costs - Subsection
## 1.1 hardware - chapter
### 1.1.1 compute - Section
#### 1.1.1.1 Single Board Computer - Subsection
##### 1.1.1.1.1 Raspberry Pi - Sub-subsection
#### 1.1.1.2 Mini PCs - Small Form Factor PCs - Subsection
##### 1.1.1.2.1 Intel NUC - Sub-subsection
##### 1.1.1.2.2 Lenovo ThinkCentre - Sub-subsection
#### 1.1.1.3 Cluster Boards - Subsection
##### 1.1.1.3.1 Turing Pi - Sub-subsection
### 1.1.2 power supply - Section
### 1.1.3 network - Section
#### 1.1.3.1 switch - Subsection
#### 1.1.3.2 cables - Subsection
#### 1.1.3.3 cable vs. WiFi - Subsection
#### 1.1.3.4 uplink - Subsection
### 1.1.4 storage - Section
### 1.1.5 rack - Section
## 1.2 software - chapter
### 1.2.1 operating system - Section
### 1.2.2 system management - Section
## 1.3 assembly - chapter
### 1.3.1 cable management - Section
## 1.4 base system installation - chapter
## 1.5 application installation - chapter
## 1.6 operational setup - chapter
# 2 CI/CD UiPath RPA - part
### 2.0.1 Introduction to CI/CD for UiPath RPA Projects: A Lifecycle Approach - Section
## 2.1 Dev - chapter
### 2.1.1 Code - Section
Workflow Analyzer manually

Workflow Analyzer on push?

Entrypoints (to prepare Canary testing)

Git repository template

Git repository webhooks

#### 2.1.1.1 Code Review - Subsection
#### 2.1.1.2 Debugging Git repository webhooks - Subsection
Git Client

Git branching strategy

Git merge conflicts

Object Repository: in-project

#### 2.1.1.3 Modularity and Reusability - Subsection
Object Repository: extract as library

### 2.1.2 Build - Section
compile: build both packages and libraries

sem ver

#### 2.1.2.1 Static Code Scanning - Subsection
Workflow Analyzer automated

import to SonarQube

### 2.1.3 Test - Section
Canary

bar

## 2.2 Ops - chapter
### 2.2.1 Release - Section
document release notes

Jenkinsfile(s)

approval

### 2.2.2 Deploy - Section
Jenkinsfile(s)

### 2.2.3 Operate - Section
#### 2.2.3.1 Role-Based Access Control (RBAC) - Subsection
#### 2.2.3.2 Credentials Management - Subsection
### 2.2.4 Monitor - Section
rescan code

## 2.3 Iterate Dev - chapter
### 2.3.1 plan - Section
# 3 Appendix - part
# 4 Glossary - part
# 5 Bibliography/References - part
# 6 Index - part