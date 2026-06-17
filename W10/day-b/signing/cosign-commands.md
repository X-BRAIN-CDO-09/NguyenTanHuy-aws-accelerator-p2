# Cosign Signing Commands

## Keyless Signing

Keyless signing dùng OIDC identity từ GitHub Actions hoặc user identity. Không cần quản lý private key dài hạn.

```bash
cosign sign --yes ghcr.io/example/platform-api:1.0.0
```

Verify image keyless:

```bash
cosign verify \
  --certificate-identity-regexp 'https://github.com/example/.github/workflows/.+' \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com \
  ghcr.io/example/platform-api:1.0.0
```

## Key-Based Signing

Tạo key pair:

```bash
cosign generate-key-pair
```

Ký image:

```bash
cosign sign --key cosign.key ghcr.io/example/platform-api:1.0.0
```

Verify image:

```bash
cosign verify --key cosign.pub ghcr.io/example/platform-api:1.0.0
```

## Production Notes

- Ưu tiên keyless signing với OIDC để giảm rủi ro lộ private key.
- Nếu dùng key-based signing, lưu private key trong KMS hoặc secret manager, không commit vào Git.
- Luôn verify theo immutable digest trong pipeline release.
- Ghi lại image digest, signer identity và thời điểm ký trong evidence.

