# Roles & Permissions — QR Code Generator

## Roles

| Role | Description |
|---|---|
| Owner | Creates and manages codes in their own workspace. |
| Viewer | Reads scan analytics for codes shared with them. |

## Policy

| Role | Resource | Action | Allowed |
|---|---|---|---|
| Owner | Code | create · edit · delete | yes |
| Viewer | Analytics | read | yes |
