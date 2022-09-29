#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <time.h>
#include "prog1.h"
#define STB_IMAGE_IMPLEMENTATION
#include "stb/stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb/stb_image_write.h"


int main(int argc, char* argv[])
{
	if (argc != 4)
	{
		fprintf(stderr, "Program shoul recieve 3 argument, but %d were recieved.\n", argc - 1);
		return 1;
	}
	int w, h, c;
	unsigned char* img = stbi_load(argv[1], &w, &h, NULL, 4);

	if (img == NULL)
	{
		fprintf(stderr, "Not an image file\n");
		return 1;
	}

	const char* c_filename = argv[2];
	const char* s_filename = argv[3];

	int new_w, new_h, new_w1, new_h1;
	printf("Enter the first angle: ");
	scanf("%d %d", &new_w, &new_h);
	printf("Enter the second angle: ");
	scanf("%d %d", &new_w1, &new_h1);

	time_t t = clock();

	scale_bmp(img, w, h, new_w, new_h, new_w1, new_h1);
	//t = time(NULL) - t;
	printf("C:	%d\n", clock() - t);

	stbi_write_bmp(c_filename, new_w1-new_w, new_h1-new_h, 4, img);

	t = clock();
	asm_scale_bmp(img, w, h, new_w, new_h, new_w1, new_h1);
	//t = time(NULL) - t;
	printf("ASM:	%d\n", clock() - t);

	stbi_write_bmp(s_filename, new_w1-new_w, new_h1-new_h, 4, img);

	stbi_image_free(img);
	return 0;
}
