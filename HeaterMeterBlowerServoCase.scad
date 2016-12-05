HARDWARE_SIZE = 4;
DIMENSIONS = [70, 115, 60];
WALL_THICKNESS = 4;
BLOWER_DIMENSIONS = [60, 60, 25];
BLOWER_MOUNT_CENTER_OFFSET = 25;
LAYER_HEIGHT = 0.3;
TOLERANCE = 0.1;
pf = 0.1;

use <MCAD/polyholes.scad>
include <MCAD/nuts_and_bolts.scad>
use <nuttrap.scad>

main(true);

module main(print)
{
    blower_plate();
}

module blower_plate()
{
    blower_offset = ((DIMENSIONS[1] - BLOWER_DIMENSIONS[1]) / 2) - 10;
    
    difference()
    {
        union()
        {
            translate([0, 0, WALL_THICKNESS/2])
            {
                cube([DIMENSIONS[0], DIMENSIONS[1], WALL_THICKNESS], center=true);
            }

            translate([0, blower_offset, WALL_THICKNESS])
            {
                for(i=[-1:2:1])
                {
                    translate([i*BLOWER_MOUNT_CENTER_OFFSET, BLOWER_MOUNT_CENTER_OFFSET, 0])
                    {
                        rotate([0, 0, -90])
                        {
                            blower_standoff();
                        }
                    }

                    translate([i*BLOWER_MOUNT_CENTER_OFFSET, -BLOWER_MOUNT_CENTER_OFFSET, 0])
                    {
                        rotate([0, 0, 90])
                        {
                            blower_standoff();
                        }
                    }
                }
            }
        }
    }
    
}

module blower_standoff()
{
    standoff_height = (DIMENSIONS[2] - 2*WALL_THICKNESS - BLOWER_DIMENSIONS[2])/2 + pf;
    standoff_width = 10;
    nut_trap_height = METRIC_NUT_THICKNESS[HARDWARE_SIZE]+TOLERANCE;

    translate([0, 0, standoff_height/2])
    {
        difference()
        {
            cube([standoff_width, standoff_width, standoff_height], center=true);
            nutTrap(HARDWARE_SIZE, standoff_width/2, TOLERANCE);
            
            translate([0, 0, -standoff_height/2])
            {
                polyhole(standoff_height/2, HARDWARE_SIZE);
            }

            translate([0, 0, nut_trap_height/2 + LAYER_HEIGHT])
            {
                polyhole(standoff_height/2, HARDWARE_SIZE);
            }
        }
    }
}
