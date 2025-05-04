# Nix Nitro Enclave

## Nitro Enclave Reproducible Builds

First, build enclave locally and obtain PCR measurements:

```
$ nix build
[...]
$ cat result/pcr.json
{
  "HashAlgorithm": "Sha384 { ... }",
  "PCR0": "907f56dd12ad37f22c584d599778d4d67e5f1f7bc1efc3f8f8a6f6e83ed4ec6d8d2db750e159d515bc876a1c662df09f",
  "PCR1": "f620faebea2b9ac731aca5339da7a16b36260a779e850d7c6a616fe0e08d119177e8ce3a8b9ff19873be021a69529627",
  "PCR2": "4f044826d5d94293a5e4e4d5afd5008b8accf4f2c1d88eeab86d634e594819da2787f2c4cc5cc2bde5bee7d859ba7a2a"
}
```

Confirm build reproducibility from another host:
```
$ nix build github:ddz/nix-nitro-enclave
[...]
$ cat ./result/pcr.json
{
  "HashAlgorithm": "Sha384 { ... }",
  "PCR0": "907f56dd12ad37f22c584d599778d4d67e5f1f7bc1efc3f8f8a6f6e83ed4ec6d8d2db750e159d515bc876a1c662df09f",
  "PCR1": "f620faebea2b9ac731aca5339da7a16b36260a779e850d7c6a616fe0e08d119177e8ce3a8b9ff19873be021a69529627",
  "PCR2": "4f044826d5d94293a5e4e4d5afd5008b8accf4f2c1d88eeab86d634e594819da2787f2c4cc5cc2bde5bee7d859ba7a2a"
}
```

## Development

Enter multiple development shells with `nix develop` and run the following:

1. Run the vsock forwarder to forward vsock connections from the enclave VM to
   VMADDR_CID_LOCAL (1) instead of CID 3 (the owning EC2 instance):
```
$ ./scripts/vhost-device-vsock.sh
```

2. Run the heartbeat server:
```
$ ./scripts/heartbeat.sh
```

3. Run the HTTP forwarder:
```
$ ./scripts/http-forwarder.sh
```

4. Build the enclave image as ./result/image.eif
```
$ nix build
```

5. Run the enclave image in a simulated Nitro Enclave using QEMU:
```
$ ./scripts/qemu.sh
```

Now you should be able to dump the `enclave` debug vars:
```
$ curl http://localhost:8080/debug/vars
```

## References
- [QEMU nitro-enclave machine type](https://www.qemu.org/docs/master/system/i386/nitro-enclave.html)
- [Linux Kernel Nitro Enclaves Support](https://www.kernel.org/doc/html/latest/virt/ne_overview.html)
- [Bootstrap for AWS Nitro Enclaves](https://github.com/aws/aws-nitro-enclaves-sdk-bootstrap)
- [AWS Nitro Enclaves SDK for C](https://github.com/aws/aws-nitro-enclaves-sdk-c)
