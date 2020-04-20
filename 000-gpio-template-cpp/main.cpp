#include <gpiod.hpp>
#include <iostream>

#define GPIO_DEVICE   "gpiochip0"
#define GPIO_LINE     (0)
#define GPIO_CONSUMER "gpio_state"


int main() 
{
  gpiod::chip chip(GPIO_DEVICE);
  auto line = chip.get_line(GPIO_LINE);

  gpiod::line_request request = {
    GPIO_CONSUMER,
    gpiod::line_request::DIRECTION_INPUT,
    0
  };

  line.request(request, 0);

  auto value = line.get_value();

  std::cout << "GPIO value is: " << value << std::endl;

  return 0;
}