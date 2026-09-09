# File Uploads & Imports

Applicable to local uploads, remote imports, archives, media/doc processing.

Check:
- server-side size/type validation;
- storage/public-access model;
- active/executable content handling;
- filename/path traversal;
- object read/delete authorization;
- signed URL scope/expiry;
- decompression limits;
- processing-library risk.

## Checks
- `SEC-UPLOAD-001` HIGH: untrusted active/executable content can be served from
  a trusted application origin unsafely.
- `SEC-UPLOAD-002` HIGH: filename/path handling permits traversal or overwrite.
- `SEC-UPLOAD-003` HIGH/MEDIUM: upload/read/delete authorization is missing.
- `SEC-UPLOAD-004` MEDIUM: unbounded upload/decompression permits resource
  exhaustion.
