use <MCAD/polyholes.scad>
include <MCAD/nuts_and_bolts.scad>
use <nuttrap.scad>

HARDWARE_SIZE = 3;
HARDWARE_HEAD_DEPTH = 3.5;
HARDWARE_HEAD_DIAMETER = 5.6;
DIMENSIONS = [78, 115, 60];
WALL_THICKNESS = 8;
BLOWER_DIMENSIONS = [60, 60, 25];
BLOWER_MOUNT_CENTER_OFFSET = 25;
BLOWER_HARDWARE_SIZE = 4;
LAYER_HEIGHT = 0.3;
TOLERANCE = 0.2;
pf = 0.1;

main(true);

module main(print)
{
    translate([print ? -DIMENSIONS[0]/2 : 0, 0, 0])
    {
        blower_plate();
    }

    translate([print ? DIMENSIONS[0]/2 : 0, 0, print ? 0 : DIMENSIONS[2]])
    {
        rotate([0, print ? 0 : 180, 0])
        {
            cover_plate();
        }
    }

    translate([print ? -DIMENSIONS[0]/2 - 2 : 0, print ? DIMENSIONS[1] : DIMENSIONS[1]/2, print ? 0 : DIMENSIONS[2]/2])
    {
        rotate([print ? 0 : 90, 0, 0])
        {
            top_plate();
        }
    }
}

module blower_plate()
{
    side_plate();

    blower_offset = ((DIMENSIONS[1] - BLOWER_DIMENSIONS[1]) / 2) - (BLOWER_DIMENSIONS[2]/2);
    translate([0, blower_offset, WALL_THICKNESS])
    {
        for(i=[-1:2:1])
        {
            translate([i*BLOWER_MOUNT_CENTER_OFFSET, BLOWER_MOUNT_CENTER_OFFSET, 0])
            {
                rotate([0, 0, 90])
                {
                    blower_standoff();
                }
            }

            translate([i*BLOWER_MOUNT_CENTER_OFFSET, -BLOWER_MOUNT_CENTER_OFFSET, 0])
            {
                rotate([0, 0, -90])
                {
                    blower_standoff();
                }
            }
        }
    }
}

module cover_plate()
{
    side_plate();
}

module top_plate()
{
    end_plate();
}

module end_plate()
{
    plate_x = DIMENSIONS[0];
    plate_y = DIMENSIONS[2];

    difference()
    {
        translate([0, 0, WALL_THICKNESS/2])
        {
            cube([DIMENSIONS[0], DIMENSIONS[2], WALL_THICKNESS], true);
        }

        for(i=[-1:2:1])
        {
            translate([i*plate_x/2 - i*WALL_THICKNESS/2, 0, 0])
            {
                translate([0, plate_y/4, 0])
                {
                    plate_bolt_hole();
                }

                translate([0, -plate_y/4, 0])
                {
                    plate_bolt_hole();
                }

                translate([i*-plate_x/4, plate_y/2 - WALL_THICKNESS/2, 0])
                {
                    rotate([0, 0, 90])
                    {
                        plate_bolt_hole();
                    }
                }

                translate([i*-plate_x/4, -plate_y/2 + WALL_THICKNESS/2, 0])
                {
                    rotate([0, 0, 90])
                    {
                        plate_bolt_hole();
                    }
                }
            }
        }
    }
}

module side_plate()
{
    plate_x = DIMENSIONS[0] - 2*WALL_THICKNESS;
    plate_y = DIMENSIONS[1] - 2*WALL_THICKNESS;
    
    
    difference()
    {
        translate([0, 0, WALL_THICKNESS/2])
        {
            cube([plate_x, plate_y, WALL_THICKNESS], center=true);
        }

        for(i=[-1:2:1])
        {
            translate([i*plate_x/2 - i*3, 0, 0])
            {
                translate([0, plate_y/4, 0])
                {
                    plate_nut_trap();
                }

                translate([0, -plate_y/4, 0])
                {
                    plate_nut_trap();
                }

                translate([i*-plate_x/4, plate_y/2 - 3, 0])
                {
                    rotate([0, 0, 90])
                    {
                        plate_nut_trap();
                    }
                }

                translate([i*-plate_x/4, -plate_y/2 + 3, 0])
                {
                    rotate([0, 0, 90])
                    {
                        plate_nut_trap();
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
    nut_trap_height = METRIC_NUT_THICKNESS[BLOWER_HARDWARE_SIZE]+TOLERANCE;

    translate([0, 0, standoff_height/2])
    {
        difference()
        {
            cube([standoff_width, standoff_width, standoff_height], center=true);
            nutTrap(BLOWER_HARDWARE_SIZE, standoff_width/2, TOLERANCE);
            
            translate([0, 0, -standoff_height/2])
            {
                polyhole(standoff_height/2, BLOWER_HARDWARE_SIZE);
            }

            translate([0, 0, nut_trap_height/2 + LAYER_HEIGHT])
            {
                polyhole(standoff_height/2, BLOWER_HARDWARE_SIZE);
            }
        }
    }
}

module plate_nut_trap()
{
    translate([0, 0, WALL_THICKNESS/2])
    {
        rotate([0, -90, 0])
        {
            nutTrap(HARDWARE_SIZE, WALL_THICKNESS/2+pf, TOLERANCE);
            
            translate([0, 0, -10])
            {
                polyhole(20, HARDWARE_SIZE);
            }
        }
    }
}

module plate_bolt_hole()
{
    translate([0, 0, -pf/2])
    {
        polyhole(HARDWARE_HEAD_DEPTH, HARDWARE_HEAD_DIAMETER);
        translate([0, 0, HARDWARE_HEAD_DEPTH + LAYER_HEIGHT])
        {
            polyhole(WALL_THICKNESS - HARDWARE_HEAD_DEPTH + pf, HARDWARE_SIZE);
        }
    }
}
