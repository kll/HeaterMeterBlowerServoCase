use <MCAD/polyholes.scad>
include <MCAD/nuts_and_bolts.scad>
use <nuttrap.scad>

HARDWARE_SIZE = 3;
DIMENSIONS = [78, 115, 60];
WALL_THICKNESS = METRIC_NUT_AC_WIDTHS[HARDWARE_SIZE] + 1;
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
}

module blower_plate()
{
    plate(true);
}

module cover_plate()
{
    plate(false);
}

module plate(standoffs)
{
    plate_x = DIMENSIONS[0] - 2*WALL_THICKNESS;
    plate_y = DIMENSIONS[1] - 2*WALL_THICKNESS;
    blower_offset = ((DIMENSIONS[1] - BLOWER_DIMENSIONS[1]) / 2) - (BLOWER_DIMENSIONS[2]/2);
    
    difference()
    {
        union()
        {
            translate([0, 0, WALL_THICKNESS/2])
            {
                cube([plate_x, plate_y, WALL_THICKNESS], center=true);
            }

            if (standoffs)
            {
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
        }

        for(i=[-1:2:1])
        {
            translate([i*plate_x/2 - i*3, 0, 0])
            {
                translate([0, plate_y/4, 0])
                {
                    plate_mount();
                }

                translate([0, -plate_y/4, 0])
                {
                    plate_mount();
                }

                translate([i*-plate_x/4, plate_y/2 - 3, 0])
                {
                    rotate([0, 0, 90])
                    {
                        plate_mount();
                    }
                }

                translate([i*-plate_x/4, -plate_y/2 + 3, 0])
                {
                    rotate([0, 0, 90])
                    {
                        plate_mount();
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

module plate_mount()
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
