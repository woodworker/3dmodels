// 6 * 4 = 24 = enough for E24 series
drawerCountV = 6;
drawerCountH = 4;

// x1, x10, x100, x1K, x10K, x100K, x1M = 7 values
drawerSubsections = 7;

drawerCountTotal = drawerCountV * drawerCountH;

// ikea kallax standard
boxSides = 330;
boxDepth = 370;

E_24 = [100,110,120,130,150,160,180,200,220,240,270,300,330,360,390,430,470,510,560,620,680,750,820,910];

// default balsa wood thickness
materialThickness = 4;

fingerGroove = 20;

drawerHeight = (boxSides-(2*materialThickness))/(drawerCountV);
drawerWidth = (boxSides-(materialThickness))/(drawerCountH);

subsectionWidth = (boxDepth-(2*materialThickness))/drawerSubsections;

innerDrawerWidth = drawerWidth-(materialThickness*2);
innerDrawerHeight = drawerHeight-(materialThickness*2);

/**/
union() {
    difference() {
        cube([
            boxSides,
            boxDepth,
            boxSides
        ]);
        translate([
            materialThickness,
            -materialThickness,
            materialThickness
        ])
        cube([
            boxSides-(materialThickness*2),
            boxDepth+(materialThickness*2),
            boxSides-(materialThickness*2)
        ]);
    }

    for (row = [1:(drawerCountV-1)]) {
        translate([
            materialThickness/2,
            0,
            (drawerHeight*row)
        ])
        
        cube([
            boxSides-materialThickness,
            boxDepth,
            materialThickness
        ]);
    }

    for (col = [1:(drawerCountH-1)]) {
        translate([
            drawerWidth*col,
            0,
            materialThickness/2
        ])
        
        cube([
            materialThickness,
            boxDepth,
            boxSides-materialThickness
        ]);
    }
}

/**/
translate([
    materialThickness*1.5,
    0,
    materialThickness*1.5
])
/**/

/**

rotate([90,0,0]) {
    linear_extrude(height = 5) {
       text(str(drawerWidth));
    }
}

/**/
for (row = [0:(drawerCountV-1)]) {
    
    for (col = [0:(drawerCountH-1)]) {
        number = ((col+1)+(row*drawerCountH));
        
        translate([
            materialThickness*1.5 + (drawerWidth*col),
            -((row+col)*(materialThickness*5)),
            materialThickness*1.5 + (drawerHeight*row)
        ])

        union() {
            rotate([90,0,0]) {
                linear_extrude(height = materialThickness/2) {
                   text(str(E_24[number-1]));
                }
            }
            difference() {
                union() {
                    difference() {
                        cube([
                            innerDrawerWidth,
                            boxDepth,
                            innerDrawerHeight
                        ]);

                        translate([
                            materialThickness,
                            materialThickness,
                            materialThickness*2
                        ])

                        cube([
                            innerDrawerWidth-(materialThickness*2),
                            boxDepth-(materialThickness*2),
                            innerDrawerHeight
                        ]);
                    }


                    for (depth = [1:(drawerSubsections)]) {
                        depthNum = pow(10,depth-1);
                        
                        translate([
                            0,
                            (subsectionWidth*depth)+materialThickness,
                            0
                        ])
                        union(){
                            
                            rotate([90,0,0]) {
                                translate([
                                    materialThickness*2,
                                    innerDrawerHeight-((fingerGroove/3)+materialThickness),
                                    0
                                ])
                                linear_extrude(height = materialThickness/2) {
                                    
                                    EVALUE = E_24[number-1]/100;
                                    if (depthNum >= 1000000) {
                                        text(str((depthNum/1000000)*EVALUE,"M"), size = fingerGroove/3);
                                    } else if (depthNum>=1000) {
                                        text(str((depthNum/1000)*EVALUE,"K"), size = fingerGroove/3);
                                    } else {
                                        text(str(depthNum*EVALUE), size = fingerGroove/3);
                                    }
                                }
                            }
                            if (depth<drawerSubsections) {
                                cube([
                                    innerDrawerWidth,
                                    materialThickness,
                                    innerDrawerHeight
                                ]);
                            }
                        }
                    }
                }

                union() {
                    translate([
                        innerDrawerWidth/2,
                        -(materialThickness/2),
                        innerDrawerHeight
                    ])
                    rotate([0,90,90]) {
                        cylinder(materialThickness*2, fingerGroove, fingerGroove);
                    }
                }
            }
        }
    }
}
/**/
