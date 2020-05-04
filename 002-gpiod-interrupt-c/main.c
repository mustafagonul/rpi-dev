#include <gpiod.h>
#include <stdio.h>

#define GPIO_DEVICE "/dev/gpiochip0"
#define GPIO_LINE   (3)


int main() 
{
  struct gpiod_chip *chip = NULL;
  struct gpiod_line *line = NULL;
  struct gpiod_line_event event;
  int req = -1; 
  int ret = -1;
  int value = 0;

  chip = gpiod_chip_open(GPIO_DEVICE);
  if (!chip)
    return -1;

	line = gpiod_chip_get_line(chip, GPIO_LINE);
	if (!line) {
		gpiod_chip_close(chip);
		return -1;
	}

    ret = gpiod_line_request_rising_edge_events(line, "gpio_event");
	if (req) {
        printf("Events are not supported!\n");

		gpiod_chip_close(chip);
		return -1;
	}

    while (1) {
        printf("Waiting started...\n");

		gpiod_line_event_wait(line, NULL);
 
        printf("Waiting finished.\n");

		if (gpiod_line_event_read(line, &event) != 0)
			continue;
 
		if (event.event_type != GPIOD_LINE_EVENT_RISING_EDGE)
			continue;

        value = gpiod_line_get_value(line);

        printf("GPIO value is: %d\n", value);
    }

	gpiod_chip_close(chip);

    return 0;
}