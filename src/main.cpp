#include <qrencode.h>
#include <iostream>
#include <fstream>
#include <fmt/core.h>


int main() {
    const char* data = "nix is awesome";


    QRcode* qr = QRcode_encodeString(data, 0, QR_ECLEVEL_L, QR_MODE_8, 1);
    if(!qr) {
      fmt::print(stderr, "QR code generation failed\n");
      return -1;
    }

    for(int y = 0; y < qr->width; y++) {
        for(int x = 0; x < qr->width; x++) {
	  fmt::print((qr->data[y * qr->width + x] & 1) ? "##" : "  ");
        }
	fmt::print("\n");
    }

    QRcode_free(qr);
    return 0;
}
