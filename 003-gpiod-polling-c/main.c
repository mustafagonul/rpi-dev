#include <gpiod.h>
#include <stdio.h>
#include <unistd.h>

#define GPIO_DEVICE "/dev/gpiochip0"
#define GPIO_LINE   (3)


int main() 
{
  struct gpiod_chip *chip = NULL;
  struct gpiod_line *line = NULL;
  int req = -1; 
  int value = 0;
  int state = -1;

  chip = gpiod_chip_open(GPIO_DEVICE);
  if (!chip)
    return -1;

	line = gpiod_chip_get_line(chip, GPIO_LINE);
	if (!line) {
		gpiod_chip_close(chip);
		return -1;
	}

	req = gpiod_line_request_input(line, "gpio_polling");
	if (req) {
		gpiod_chip_close(chip);
		return -1;
	}

    printf("Application started!");

    do {
        value = gpiod_line_get_value(line);

        if (value != state) {
            printf("GPIO value is: %d\n", value);
            state = value;
        }

        sleep(1);
    }
    while (1);

	gpiod_chip_close(chip);

    return 0;
}