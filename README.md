## HabotConnect Hiring Project

**Name:** Pittala Sumith

**Email:** sumithpittala@gmail.com

**Mobile No:** +91 8790553948

**Position:** Junior Cloud & DevOps Engineer

---

## Project Overview

This repository contains the complete deployment and automation blueprint designed to remediate staging vulnerabilities and restore operational integrity for HabotConnect's Learning Support Assistant (LSA) platform. 

The architecture enforces absolute structural discipline through declarative Infrastructure-as-Code (IaC), automated "Poka-Yoke" mistake-proofing build gates, and deterministic binary data schema validation.

---

## Directory Layout

```text
habot-hiring-project/
├── .github/
│   └── workflows/
│       └── poka-yoke-gate.yml      # Automated fail-closed CI/CD pipeline
├── terraform/
│   ├── main.tf                    # Core GCS, BigQuery, & RLS infrastructure
│   ├── variables.tf               # Environment variables & project params
│   └── outputs.tf                 # Exported infrastructure endpoints
├── backend/
│   ├── apps/
│   │   └── onboarding/
│   │       ├── models.py          # Django ORM student onboarding model
│   │       ├── serializers.py     # DRF strict field serializers
│   │       └── logic_dcyn.py      # Binary Data/Code Yes-No (DCYN) engine
│   └── requirements.txt           # Explicitly pinned python dependencies
├── presentation/
│   ├── project_presentation.pptx  # PPT explaining the project                    
│   ├── onboarding_schema_mapping.xlsx
└── README.md                      # System documentation
```

Google Sheets link to the schema mapping -

https://docs.google.com/spreadsheets/d/1HVoi-SH_Szr0OkBRl1BKaLem70jqD5dz8jdEpFAQSOM/edit?usp=sharing

## System Architecture & Technical Specifications

_Task 1 - Infrastructure-as-Code (Terraform)GCS Raw Landing Bucket (DO Raw Landing):_

Configured with uniform bucket-level access, forced KMS customer-managed encryption, and public access prevention (public_access_prevention = "enforced").  BigQuery Dataset (D1 Staged/Enforced): Provisioned with explicit role-based access control (RBAC) separating raw landing access from reporting datasets.  Row-Level Security (RLS): Applies dynamic row filtering using google_bigquery_row_access_policy based on SESSION_USER() values to enforce tenant isolation.

_Task 2 - Poka-Yoke Automated CI/CD Build Gate_

Fail-Closed Engine designed via GitHub Actions (poka-yoke-gate.yml) to halt, fail, and quarantine pull requests upon detecting credential leaks, formatting discrepancies, or syntax errors.  Integrated Scanners:Secret Scanning: trufflesecurity/trufflehog-actions-scan for detecting high-entropy string leaks.  Format Verification: black --check for mandatory code style adherence.  Static Security Analysis: flake8 and bandit for identifying risky Python operations.

_Task 3 - Schema Mapping & DCYN Logic Validation_

Binary DCYN Engine (logic_dcyn.py): Converts ambiguous onboarding attributes into strict, deterministic boolean logic (True/False) to remove subjective interpretation.  Django REST Framework Serializers (serializers.py): Enforces strict field typing, exact length boundaries, and regex validations to reject non-compliant payloads before data touches BigQuery sinks

## Local Setup & Deployment Instructions

_1. Provision Infrastructure via Terraform_

Ensure you have the Google Cloud SDK and Terraform >= 1.5.0 installed.

``
cd terraform/
``

``
terraform init
``

``
terraform validate
``

``
terraform plan -out=tfplan.binary
``

``
terraform apply tfplan.binary
``

_2. Configure Backend Application_

Initialize Python environment and install pinned dependencies:

``
cd backend/
``

``
python -m venv venv
``

``
source venv/bin/activate 
``

``
pip install -r requirements.txt
``

``
python manage.py check
``

_3. Verify Poka-Yoke Pipeline Locally_

Test formatting and security scanners manually prior to committing:

``
black --check backend/
``

``
flake8 backend/ --count --select=E9,F63,F7,F82 --show-source
``

``
bandit -r backend/
``

## Verification & Golden Rules Checklist

[x] Zero Reliance on Placeholders: All parameters, fields, and variables are explicitly declared.  

[x] Fail-Closed Enforcement: Confirmed build pipeline exits with non-zero status on unencrypted secrets.

[x] Full Terms Standard: All documentation and spreadsheet mapping files utilize complete descriptive names without abbreviations.
