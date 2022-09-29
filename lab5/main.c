#include <time.h>
#include <inttypes.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#define STB_IMAGE_WRITE_IMPLEMENTATION
#define STB_IMAGE_IMPLEMENTATION
#define STBI_FAILURE_USERMSG
#include "stb_image.h"
#include "stb_image_write.h"

int work(char *input, char *output, int x1, int y1, int x2, int y2);
void process(uint8_t *image, uint32_t width, uint32_t height, int x1, int y1, int x2, int y2);
void process_asm(uint8_t *image, uint32_t width, uint32_t height, int x1, int y1, int x2, int y2);

int main(int argc, char **argv) {
    if(argc < 3) {
        printf("provide input and output files\n");
        return 0;
    }

    if(access(argv[1], R_OK) != 0) {
        printf("error opening input file %s\n", argv[1]);
        return 0;
    }

    int x1, x2, y1, y2;
    //printf("Input one corner: ");
    scanf("%d %d", &x1, &y1);
    //printf("Input second corner: ");
    scanf("%d %d", &x2, &y2);

    int ret = work(argv[1], argv[2], x1, y1, x2, y2);
    return ret;
}

int work(char *input, char *output, int x1, int y1, int x2, int y2) {
    int w, h;
    unsigned char *data = stbi_load(input, &w, &h, NULL, 4);
    
    if (data == NULL) {
        puts(stbi_failure_reason());
        return 1;
    }

    if (x1 < 0)
        x1 = 0;
    if (x2 < 0)
        x2 = 0;
    if (x1 > w)
        x1 = w;
    if (x2 > w)
        x2 = w;

    if (y1 < 0)
        y1 = 0;
    if (y2 < 0)
        y2 = 0;
    if (y1 > h)
        y1 = h;
    if (y2 > h)
        y2 = h;

    if (x1 > x2) {
        int tmp = x1;
        x1 = x2;
        x2 = tmp;
    }
    if (y1 > y2) {
        int tmp = y1;
        y1 = y2;
        y2 = tmp;
    }

    if (x1 == x2 || y1 == y2) {
        printf("Error with coordinates\n");
        stbi_image_free(data);
        return 1;
    }

    size_t size = w * h * 4;
    clock_t begin = clock();

    #ifdef ASM
        process_asm(data, w, h, x1, y1, x2, y2);
    #else
        process(data, w, h, x1, y1, x2, y2);
    #endif
    
    clock_t end = clock();
    // printf("processing time: %lf\n", time_spent);
    printf("%lf", (double)(end - begin) / CLOCKS_PER_SEC);
    
    if (stbi_write_bmp(output, x2 - x1, y2 - y1, 4, data) == 0) {
        puts("Some bmp writing error\n");
        stbi_image_free(data);
        return 1;
    }

    stbi_image_free(data);
    return 0;
}


void process(uint8_t *image, uint32_t width, uint32_t height, int x1, int y1, int x2, int y2) {
    uint32_t* pixels = (uint32_t*)image;
    register int i = 0;
    for (register int y = y1; y < y2; y += 1) {
        for (register int x = x1; x < x2; x += 1) {
            pixels[i] = pixels[y * width + x];
            i += 1;
        }
    }
}
