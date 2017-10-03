$fs=0.01;
//$fa=0.1;

mm = 1/25.4;

battery_height = 65 * mm;
battery_radius = 9 * mm;
battery_gap = 2 * mm;
spring_gap = 2 * mm;
box_wall = 4 * mm;
box_height = (battery_radius * 2);
board_width = 26 * mm;
board_height = 58 * mm;
board_thick = 3 * mm;

usb_height = 5 * mm;
usb_width = 12.5 * mm;
usb_thick = 11 * mm;

lcd_width = 13.5  * mm;
lcd_length = 28.5 * mm;
lcd_thick = 5 * mm;


module battery()
{
  linear_extrude(battery_height)
  {
    circle(battery_radius, $fn=60);
  }
}

module battery_box()
{
  y = (spring_gap + box_wall) * 2 + battery_height;
  x = (battery_radius * 2) * 6 + (battery_gap * 5) + ((box_wall + spring_gap) * 2);
  
  translate([x/2, 0, y/2])
  rotate([90, 0, 0])
  linear_extrude(box_height)
  {
    difference()
    {
      square([x, y], center = true);
      square([x - box_wall * 2, y - box_wall * 2], center = true);
    }
  }

  x2 = board_width + box_wall;
  
  translate([x + x2/2, 0, y/2])
  rotate([90, 0, 0])
  linear_extrude(box_height)
  {
    difference()
    {
      square([x2, y], center = true);
      square([board_width, board_height], center = true);
    }
  }
 
}


module lcd()
{
  rotate([90, 0, 0])
  {
    linear_extrude(lcd_thick)
    {
      square([lcd_width, lcd_length]);
    }
  }
}

module lcd_text()
{

  translate([4 * mm, -4 * mm, lcd_length - 8 * mm])
  rotate([90, 90, 0])
  {
    linear_extrude(1.1 * mm) text("80%", size=6*mm);
  }
}


module board()
{
  // LCD
  rotate([90, 0, 0])
  {
    
    linear_extrude(board_thick)
    {
      square([board_width, board_height]);
    }
  }
  
}

module usb()
{
  rotate([0, 90, 0])
  {
    linear_extrude(usb_thick)
    {
      difference()
      {
        square([usb_width, usb_height], true);
        square([usb_width-1*mm, usb_height-1*mm], true);
      }
    }
  }
}


module usb_slot()
{
  rotate([0, 90, 0])
  {
    linear_extrude(usb_thick + 6 * mm)
    {
      square([usb_width-mm, usb_height-mm], true);
    }
  }
}

color("green") 
translate([battery_radius + box_wall + spring_gap, -battery_radius, box_wall + spring_gap])
{
  for(n=[0:1:5])
  {
    translate([n * (battery_radius * 2 + battery_gap), -0, 0])
    {
      battery();
    }
  }
}



x = (battery_radius * 2) * 6 + (battery_gap * 5) + ((box_wall + spring_gap) * 2) + box_wall/2;
z = (((spring_gap + box_wall) * 2 + battery_height) - board_height) / 2;
y = box_height - (board_thick + lcd_thick);

translate([x, -y, z])
{
  color("yellow")  board();

  color("white")  translate([4 * mm, -board_thick, 11 * mm]) lcd();
  color("black")  translate([4 * mm, -board_thick, 11 * mm]) lcd_text();
  
  
  color("white")  translate([board_width-usb_thick, usb_height/2, usb_width/2 + 6 * mm]) usb();
  color("white")  translate([board_width-usb_thick, usb_height/2, usb_width/2 + 31 * mm]) usb();

}

// Cut out slots for USB
color("red")
difference()
{
  battery_box();

  translate([x, -y, z])
  {
    translate([board_width, usb_height/2, usb_width/2 + 6 * mm]) usb_slot();
    translate([board_width, usb_height/2, usb_width/2 + 31 * mm]) usb_slot();
  }
  
}

//outerbox extendable
module extend_box()
{
  y = (spring_gap + box_wall) * 2 + battery_height + 4*mm;
  x = (battery_radius * 2) * 6 + (battery_gap * 5) + ((box_wall + spring_gap) * 2)+board_width + box_wall;
  innerY = (spring_gap + box_wall) * 2 + battery_height;
  innerX = (battery_radius * 2) * 6 + (battery_gap * 5) + ((box_wall + spring_gap) * 2)+board_width + box_wall;
  translate([x/2, 0, y/2])
  rotate([90, 0, 0])
  linear_extrude(box_height)
  {
    difference()
    {
      square([x, y], center = true);
      square([innerX, innerY], center = true);
    }
  }
}

color("yellow")
extend_box();


/*
color("black")
translate([x + 8 * mm, -box_height- 0.5 * mm, ])
rotate([90, 90, 0])
{
  linear_extrude(1 * mm) text("80%", size=6*mm);
}
*/