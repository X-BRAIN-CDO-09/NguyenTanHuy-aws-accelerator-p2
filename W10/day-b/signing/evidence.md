# Image Signing Evidence

## Image Đã Ký

```bash
cosign verify \
  --certificate-identity-regexp 'https://github.com/example/platform/.github/workflows/release.yml@refs/heads/main' \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com \
  ghcr.io/example/platform-api:1.0.0
```

Kết quả mong đợi:

```text
Verification for ghcr.io/example/platform-api:1.0.0 --
The following checks were performed on each of these signatures:
  - The cosign claims were validated
  - Existence of the claims in the transparency log was verified offline
  - The code-signing certificate was verified using trusted certificate authority certificates
```

## Image Chưa Ký Bị Từ Chối

Ví dụ pod dùng image chưa ký:

```bash
kubectl run unsigned-api -n apps-prod --image=ghcr.io/example/platform-api:unsigned
```

Kết quả mong đợi:

```text
admission webhook "mutate.kyverno.svc" denied the request: failed to verify image signature
```

## Evidence Checklist

- [ ] Cosign verify thành công cho image đã ký.
- [ ] Kyverno policy ở trạng thái ready.
- [ ] Pod dùng image chưa ký bị từ chối.
- [ ] Image digest được ghi lại trong release note.

