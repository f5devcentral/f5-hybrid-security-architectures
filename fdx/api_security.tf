{
  "apiVersion": "appprotect.f5.com/v1beta1",
  "kind": "APPolicy",
  "metadata": {
    "name": "api-security-blocking"
  },
  "spec": {
    "policy": {
      "name": "api-security-blocking",
      "template": {
        "name": "POLICY_TEMPLATE_NGINX_BASE"
      },
      "open-api-files": [
        {
          "link": "https://raw.githubusercontent.com/vtobi/fdx-controls-reference-implementation/main/fdx/fdxapi.yaml"
        },
        {
          "link": "https://raw.githubusercontent.com/vtobi/fdx-controls-reference-implementation/main/fdx/fdxapi.tax.yaml"
        },
        {
          "link": "https://raw.githubusercontent.com/vtobi/fdx-controls-reference-implementation/main/fdx/fdxapi.money-movement.yaml"
        },
        {
          "link": "https://raw.githubusercontent.com/vtobi/fdx-controls-reference-implementation/main/fdx/fdxapi.core.yaml"
        }
      ],
      "applicationLanguage": "utf-8",
      "enforcementMode": "blocking",
      "blocking-settings": {
        "violations": [
          {
            "name": "VIOL_MANDATORY_REQUEST_BODY",
            "alarm": true,
            "block": true
          },
          {
            "name": "VIOL_PARAMETER_LOCATION",
            "alarm": true,
            "block": true
          },
          {
            "name": "VIOL_MANDATORY_PARAMETER",
            "alarm": true,
            "block": true
          },
          {
            "name": "VIOL_JSON_SCHEMA",
            "alarm": true,
            "block": true
          },
          {
            "name": "VIOL_PARAMETER_ARRAY_VALUE",
            "alarm": true,
            "block": true
          },
          {
            "name": "VIOL_PARAMETER_VALUE_BASE64",
            "alarm": true,
            "block": true
          },
          {
            "name": "VIOL_FILE_UPLOAD",
            "alarm": true,
            "block": true
          },
          {
            "name": "VIOL_URL_CONTENT_TYPE",
            "alarm": true,
            "block": true
          },
          {
            "name": "VIOL_PARAMETER_STATIC_VALUE",
            "alarm": true,
            "block": true
          },
          {
            "name": "VIOL_PARAMETER_VALUE_LENGTH",
            "alarm": true,
            "block": true
          },
          {
            "name": "VIOL_PARAMETER_DATA_TYPE",
            "alarm": true,
            "block": true
          },
          {
            "name": "VIOL_PARAMETER_NUMERIC_VALUE",
            "alarm": true,
            "block": true
          },
          {
            "name": "VIOL_PARAMETER_VALUE_REGEXP",
            "alarm": true,
            "block": true
          },
          {
            "name": "VIOL_URL",
            "alarm": true,
            "block": true
          },
          {
            "name": "VIOL_PARAMETER",
            "alarm": true,
            "block": true
          },
          {
            "name": "VIOL_PARAMETER_EMPTY_VALUE",
            "alarm": true,
            "block": true
          },
          {
            "name": "VIOL_PARAMETER_REPEATED",
            "alarm": true,
            "block": true
          }
        ]
      }
    }
  }
}
