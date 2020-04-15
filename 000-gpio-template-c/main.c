#include <stdio.h>
#include <gpiod.h>

#define GPIO_DEVICE "/dev/gpiochip0"
#define GPIO_LINE   (3)


int main() 
{
  struct gpiod_chip *chip = NULL;
  struct gpiod_line *line = NULL;
  int req = -1; 
  int value = 0;

  chip = gpiod_chip_open(GPIO_DEVICE);
  if (!chip)
    return -1;

	line = gpiod_chip_get_line(chip, GPIO_LINE);
	if (!line) {
		gpiod_chip_close(chip);
		return -1;
	}

	req = gpiod_line_request_input(line, "gpio_state");
	if (req) {
		gpiod_chip_close(chip);
		return -1;
	}

	value = gpiod_line_get_value(line);

	printf("GPIO value is: %d\n", value);

	gpiod_chip_close(chip);

    return 0;
}