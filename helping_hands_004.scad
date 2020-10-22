/* [Immutable Parameters: Don't change these ever.] */
pi = 3.1415926535;
e = 2.7182818;

/* [Mutable Parameters] */
pitch = 0.25;
// Height of ball center from ground plane
mitt_height = 2.3;
mitt_outer_diameter = 0.85;
thread_height = 0.81;
D_minor = 0.52;
D_ball = 0.5;
D_shank = 0.52;
h_shank = 1.0;
h_ball_shank = 0.75;
lower_ball_start_angle = 40;
lower_ball_end_angle = 30;
t_shell_ball = 0.07;
t_shell_ball_shank = 0.07;
t_shell_shank = 0.09;
thread_clearance = 0.004;
// Width of slits
slit_width = 0.02; //[0.01:0.01:0.06]
// Relative Height of slits 
slit_height_ratio = 2; //[1:999]
N_slits = 6; //[3:8]
fn = 30;

// Computed Parameters
d_ball_shank = (D_ball)*sin(lower_ball_end_angle);
slit_height_offset = (h_ball_shank+(D_shank-d_ball_shank))+
                     (h_shank*(2/3))*
                     (1/(1+pow(e,-0.009*(slit_height_ratio-499))));

scale([25.4,25.4,25.4]){
    // Making Nut
    nut_body();
    // Making Bolt And Helping Hand
    helping_hand_assembly();
};

module helping_hand_assembly(){
    difference(){
        union(){
            Base_Ball();
            ball_shank();
            cone_and_shank();
            bolt_thread();
            mitt_revolve();
        };
        slits();
    };
};
module slits(){
    for (i = [0:N_slits-1]){
        theta_step = (360/N_slits);
        rotate([0,0,i*theta_step]){
            translate([0,0,slit_height_offset]){
                cube([slit_width,mitt_outer_diameter*2,mitt_height],
                     center=false,$fn=fn);
            };
        };
    };
};
module nut_body(){
    difference(){
        translate([0,0,h_ball_shank+(D_shank-d_ball_shank)+(thread_height/2)+(pitch/3)]){
            linear_extrude(height=(thread_height/3),center=true,scale=1.0,$fn=fn){
                circle(d=D_minor*2,$fn=6);
            };
        };
        union(){
            cylinder(d=D_minor+4*thread_clearance,h=10,center=false,$fn=fn);
            nut_thread();
        };
    };
};
module nut_thread(){
    translate([0,0,h_ball_shank+(D_shank-d_ball_shank)+(pitch/3)]){
        Z_start = 0;
        Z_end = Z_start + thread_height;
        R = D_minor/2;
        steps = fn*5;
        angle = (thread_height/pitch)*360;
        union(){
            // main thread loop
            for (i = [0:steps-1]){
                theta = angle*((i-0.02)/(steps));
                theta_next = angle*((i+1.02)/(steps));
                Z_center = Z_start+(Z_end-Z_start)*((i-0.02)/steps);
                Z_center_next = Z_start+(Z_end-Z_start)*((i+1.02)/steps);
                p0x = (R+thread_clearance)*cos(theta_next);
                p1x = (R+thread_clearance)*cos(theta);
                p2x = (R+(2/9)*pitch+thread_clearance)*cos(theta);
                p3x = (R+(2/9)*pitch+thread_clearance)*cos(theta_next);
                p4x = p0x;
                p5x = p1x;
                p6x = p2x;
                p7x = p3x;
                p0y = (R+thread_clearance)*sin(theta_next);
                p1y = (R+thread_clearance)*sin(theta);
                p2y = (R+(2/9)*pitch+thread_clearance)*sin(theta);
                p3y = (R+(2/9)*pitch+thread_clearance)*sin(theta_next);
                p4y = p0y;
                p5y = p1y;
                p6y = p2y;
                p7y = p3y;
                p0z = Z_center_next-(pitch/3)-(pow(2,0.5)/2)*thread_clearance;
                p1z = Z_center - (pitch/3)-(pow(2,0.5)/2)*thread_clearance;
                p2z = Z_center - (pitch/9)-(pow(2,0.5)/2)*thread_clearance;
                p3z = Z_center_next-(pitch/9)-(pow(2,0.5)/2)*thread_clearance;
                p4z = Z_center_next + (pitch/3)+(pow(2,0.5)/2)*thread_clearance;
                p5z = Z_center + (pitch/3)+(pow(2,0.5)/2)*thread_clearance;
                p6z = Z_center + (pitch/9)+(pow(2,0.5)/2)*thread_clearance;
                p7z = Z_center_next + (pitch/9)+(pow(2,0.5)/2)*thread_clearance;
                points = [[p0x,p0y,p0z],[p1x,p1y,p1z],
                          [p2x,p2y,p2z],[p3x,p3y,p3z],
                          [p4x,p4y,p4z],[p5x,p5y,p5z],
                          [p6x,p6y,p6z],[p7x,p7y,p7z]];
                faces = [[0,1,2,3],[4,5,1,0],[7,6,5,4],
                         [5,6,2,1],[6,7,3,2],[7,4,0,3]];
                polyhedron(points,faces);
            };
            // Subtractive Interference Helix
            for (i = [0:steps-1]){
                theta = angle*((i-0.02)/(steps));
                theta_next = angle*((i+1.02)/(steps));
                Z_center = Z_start+(Z_end-Z_start)*((i-0.02)/steps);
                Z_center_next = Z_start+(Z_end-Z_start)*((i+1.02)/steps);
                p0x = (R+thread_clearance-(2/9)*pitch)*cos(theta_next);
                p1x = (R+thread_clearance-(2/9)*pitch)*cos(theta);
                p2x = (R+thread_clearance)*cos(theta);
                p3x = (R+thread_clearance)*cos(theta_next);
                p4x = p0x;
                p5x = p1x;
                p6x = p2x;
                p7x = p3x;
                p0y = (R+thread_clearance-(2/9)*pitch)*sin(theta_next);
                p1y = (R+thread_clearance-(2/9)*pitch)*sin(theta);
                p2y = (R+thread_clearance)*sin(theta);
                p3y = (R+thread_clearance)*sin(theta_next);
                p4y = p0y;
                p5y = p1y;
                p6y = p2y;
                p7y = p3y;
                
                p0z = Z_center_next-(pitch/3)-(pow(2,0.5)/2)*thread_clearance;
                p1z = Z_center - (pitch/3)-(pow(2,0.5)/2)*thread_clearance;
                p2z = Z_center - (pitch/3)-(pow(2,0.5)/2)*thread_clearance;
                p3z = Z_center_next-(pitch/3)-(pow(2,0.5)/2)*thread_clearance;
                p4z = Z_center_next + (pitch/3)+(pow(2,0.5)/2)*thread_clearance;
                p5z = Z_center + (pitch/3)+(pow(2,0.5)/2)*thread_clearance;
                p6z = Z_center + (pitch/3)+(pow(2,0.5)/2)*thread_clearance;
                p7z = Z_center_next + (pitch/3)+(pow(2,0.5)/2)*thread_clearance;
                points = [[p0x,p0y,p0z],[p1x,p1y,p1z],
                          [p2x,p2y,p2z],[p3x,p3y,p3z],
                          [p4x,p4y,p4z],[p5x,p5y,p5z],
                          [p6x,p6y,p6z],[p7x,p7y,p7z]];
                faces = [[0,1,2,3],[4,5,1,0],[7,6,5,4],
                         [5,6,2,1],[6,7,3,2],[7,4,0,3]];
                polyhedron(points,faces);
            };
        };
    };
};
module mitt_revolve(){
    difference(){
        rotate_extrude($fn=fn){
            polygon( points=[[(D_shank/2)-t_shell_shank,mitt_height-(D_ball/2)],
                             [(D_shank/2)-t_shell_shank,mitt_height+(D_ball/2)+(D_shank-d_ball_shank)],
                             [mitt_outer_diameter/2,mitt_height+(D_ball/2)+(D_shank-d_ball_shank)],
                             [mitt_outer_diameter*0.45,mitt_height-(D_ball/2)+(D_shank-d_ball_shank)],
                             [D_shank/2,h_ball_shank+(D_shank-d_ball_shank)+h_shank],
                             [(D_shank/2)-t_shell_shank,h_ball_shank+(D_shank-d_ball_shank)+h_shank]]);
        };
        union(){
            translate([0,0,mitt_height]){sphere(d=0.5,$fn=fn);};
            rotate_extrude($fn=fn){
                polygon(points=[[0,mitt_height],[D_ball/2,mitt_height+D_ball/2],
                                [D_ball*3,mitt_height+D_ball/2],[D_ball*3,2*mitt_height],
                                [0,2*mitt_height]]);
            };
        };
    };
};

module bolt_thread(){
    bolt_thread_sweep();
    module bolt_thread_sweep(){
        translate([0,0,h_ball_shank+(D_shank-d_ball_shank)+(pitch/3)]){
            Z_start = 0;
            Z_end = Z_start + thread_height;
            R = D_minor/2;
            steps = fn*5;
            angle = (thread_height/pitch)*360;
            // main thread loop
            for (i = [0:steps-1]){
                theta = angle*(i/(steps));
                theta_next = angle*((i+1)/(steps));
                Z_center = Z_start+(Z_end-Z_start)*(i/steps);
                Z_center_next = Z_start+(Z_end-Z_start)*((i+1)/steps);
                if (i==0){
                    p0x = (R-thread_clearance)*cos(theta);
                    p1x = 0.9*(R-thread_clearance)*cos(angle*((i-round(steps*0.03))/(steps)));
                    p2x = 0.83*(R+(2/9)*pitch-thread_clearance)*cos(angle*((i-round(steps*0.03))/(steps)));
                    p3x = (R+(2/9)*pitch-thread_clearance)*cos(theta);
                    p4x = p0x;
                    p5x = p1x;
                    p6x = p2x;
                    p7x = p3x;

                    p0y = (R-thread_clearance)*sin(theta);
                    p1y = 0.9*(R-thread_clearance)*sin(angle*((i-round(steps*0.03))/(steps)));
                    p2y = 0.83*(R+(2/9)*pitch-thread_clearance)*sin(angle*((i-round(steps*0.03))/(steps)));
                    p3y = (R+(2/9)*pitch-thread_clearance)*sin(theta);
                    p4y = p0y;
                    p5y = p1y;
                    p6y = p2y;
                    p7y = p3y;
                    
                    p0z = Z_center-(pitch/3)+(pow(2,0.5)/2)*thread_clearance;
                    p1z = (Z_start+(Z_end-Z_start)*((i-round(steps*0.03))/steps)) - (pitch/3)+(pow(2,0.5)/2)*thread_clearance;
                    p2z = (Z_start+(Z_end-Z_start)*((i-round(steps*0.03))/steps)) - (pitch/9)+(pow(2,0.5)/2)*thread_clearance;
                    p3z = Z_center-(pitch/9)+(pow(2,0.5)/2)*thread_clearance;
                    p4z = Z_center + (pitch/3)-(pow(2,0.5)/2)*thread_clearance;
                    p5z = (Z_start+(Z_end-Z_start)*((i-round(steps*0.03))/steps)) + (pitch/3)-(pow(2,0.5)/2)*thread_clearance;
                    p6z = (Z_start+(Z_end-Z_start)*((i-round(steps*0.03))/steps)) + (pitch/9)-(pow(2,0.5)/2)*thread_clearance;
                    p7z = Z_center + (pitch/9)-(pow(2,0.5)/2)*thread_clearance;
                    points = [[p0x,p0y,p0z],[p1x,p1y,p1z],
                              [p2x,p2y,p2z],[p3x,p3y,p3z],
                              [p4x,p4y,p4z],[p5x,p5y,p5z],
                              [p6x,p6y,p6z],[p7x,p7y,p7z]];
                    faces = [[0,1,2,3],[4,5,1,0],[7,6,5,4],
                             [5,6,2,1],[6,7,3,2],[7,4,0,3]];
                    polyhedron(points,faces);
                }
                else if (i==(steps-1)){
                    p0x = 0.9*(R-thread_clearance)*cos(angle*((i+round(steps*0.04))/(steps)));
                    p1x = (R-thread_clearance)*cos(theta_next);
                    p2x = (R+(2/9)*pitch-thread_clearance)*cos(theta_next);
                    p3x = 0.83*(R+(2/9)*pitch-thread_clearance)*cos(angle*((i+round(steps*0.04))/(steps)));
                    p4x = p0x;
                    p5x = p1x;
                    p6x = p2x;
                    p7x = p3x;

                    p0y = 0.9*(R-thread_clearance)*sin(angle*((i+round(steps*0.04))/(steps)));
                    p1y = (R-thread_clearance)*sin(theta_next);
                    p2y = (R+(2/9)*pitch-thread_clearance)*sin(theta_next);
                    p3y = 0.83*(R+(2/9)*pitch-thread_clearance)*sin(angle*((i+round(steps*0.04))/(steps)));
                    p4y = p0y;
                    p5y = p1y;
                    p6y = p2y;
                    p7y = p3y;
                    
                    
                    p0z = (Z_start+(Z_end-Z_start)*((i+round(steps*0.03))/steps)) - (pitch/3)+(pow(2,0.5)/2)*thread_clearance;
                    p1z = Z_center_next - (pitch/3)+(pow(2,0.5)/2)*thread_clearance;
                    p2z = Z_center_next - (pitch/9)+(pow(2,0.5)/2)*thread_clearance;
                    p3z = (Z_start+(Z_end-Z_start)*((i+round(steps*0.03))/steps)) - (pitch/9)+(pow(2,0.5)/2)*thread_clearance;
                    p4z = (Z_start+(Z_end-Z_start)*((i+round(steps*0.03))/steps)) + (pitch/3)-(pow(2,0.5)/2)*thread_clearance;
                    p5z = Z_center_next + (pitch/3)-(pow(2,0.5)/2)*thread_clearance;
                    p6z = Z_center_next + (pitch/9)-(pow(2,0.5)/2)*thread_clearance;
                    p7z = (Z_start+(Z_end-Z_start)*((i+round(steps*0.03))/steps)) + (pitch/9)-(pow(2,0.5)/2)*thread_clearance;
                    
                    points = [[p0x,p0y,p0z],[p1x,p1y,p1z],
                              [p2x,p2y,p2z],[p3x,p3y,p3z],
                              [p4x,p4y,p4z],[p5x,p5y,p5z],
                              [p6x,p6y,p6z],[p7x,p7y,p7z]];
                    faces = [[0,1,2,3],[4,5,1,0],[7,6,5,4],
                             [5,6,2,1],[6,7,3,2],[7,4,0,3]];
                    polyhedron(points,faces);
                }
                p0x = (R-thread_clearance)*cos(theta_next);
                p1x = (R-thread_clearance)*cos(theta);
                p2x = (R+(2/9)*pitch-thread_clearance)*cos(theta);
                p3x = (R+(2/9)*pitch-thread_clearance)*cos(theta_next);
                p4x = p0x;
                p5x = p1x;
                p6x = p2x;
                p7x = p3x;

                p0y = (R-thread_clearance)*sin(theta_next);
                p1y = (R-thread_clearance)*sin(theta);
                p2y = (R+(2/9)*pitch-thread_clearance)*sin(theta);
                p3y = (R+(2/9)*pitch-thread_clearance)*sin(theta_next);
                p4y = p0y;
                p5y = p1y;
                p6y = p2y;
                p7y = p3y;
                
                p0z = Z_center_next-(pitch/3)+(pow(2,0.5)/2)*thread_clearance;
                p1z = Z_center - (pitch/3)+(pow(2,0.5)/2)*thread_clearance;
                p2z = Z_center - (pitch/9)+(pow(2,0.5)/2)*thread_clearance;
                p3z = Z_center_next-(pitch/9)+(pow(2,0.5)/2)*thread_clearance;
                p4z = Z_center_next + (pitch/3)-(pow(2,0.5)/2)*thread_clearance;
                p5z = Z_center + (pitch/3)-(pow(2,0.5)/2)*thread_clearance;
                p6z = Z_center + (pitch/9)-(pow(2,0.5)/2)*thread_clearance;
                p7z = Z_center_next + (pitch/9)-(pow(2,0.5)/2)*thread_clearance;
                
                points = [[p0x,p0y,p0z],[p1x,p1y,p1z],
                          [p2x,p2y,p2z],[p3x,p3y,p3z],
                          [p4x,p4y,p4z],[p5x,p5y,p5z],
                          [p6x,p6y,p6z],[p7x,p7y,p7z]];
                faces = [[0,1,2,3],[4,5,1,0],[7,6,5,4],
                         [5,6,2,1],[6,7,3,2],[7,4,0,3]];
                polyhedron(points,faces);
            };
        };
    };    
};
module cone_and_shank(){
    difference(){
        cone_and_shank_positive();
        cone_and_shank_negative();
    };
    module cone_and_shank_negative(){
        union(){
            translate([0,0,h_ball_shank+(D_shank-d_ball_shank)]){
                cylinder(h=h_shank+0.1,d=D_shank-2*t_shell_shank,center=false,$fn=fn);
            };
            translate([0,0,h_ball_shank]){
                cylinder(h=(D_shank-d_ball_shank),d1=d_ball_shank-2*t_shell_ball_shank,
                         d2=D_shank-2*t_shell_shank,
                         center=false,$fn=fn);
            };
            translate([0,0,h_ball_shank-0.3*(h_ball_shank-D_ball)]){
                cylinder(h=0.3*(h_ball_shank-D_ball),
                         d=d_ball_shank-2*t_shell_ball_shank,
                         center=false,$fn=fn);
            };
        };
    };
    module cone_and_shank_positive(){
        union(){
            translate([0,0,h_ball_shank+(D_shank-d_ball_shank)]){
                cylinder(h=h_shank,d=D_shank,center=false,$fn=fn);
            };
            translate([0,0,h_ball_shank]){
                cylinder(h=(D_shank-d_ball_shank),d1=d_ball_shank,d2=D_shank,center=false,$fn=fn);
            };
        };
    };
};
module ball_shank(){
    difference(){
        translate([0,0,0]){
            cylinder(h=h_ball_shank,d=d_ball_shank,center=false,$fn=fn);
        };
        union(){
            cylinder(h=h_ball_shank*5,d=d_ball_shank-2*t_shell_ball_shank,center=true,$fn=fn);
            translate([0,0,pow(((pow(cos(lower_ball_start_angle),2)*pow(D_ball,2))/4),0.5)]){
                sphere(r=D_ball/2,$fn=fn);};
        };
    };
};

module Base_Ball(){
    // Shaving Off Bottom of Ball
    difference(){
        // Constructing Base Ball
        translate([0,0,pow(((pow(cos(lower_ball_start_angle),2)*pow(D_ball,2))/4),0.5)]){
            sphere(r=D_ball/2,$fn=fn);};
        union(){
            // Shaving off bottom of Base Ball
            translate([0,0,-0.5]){cube(1,true);};
            translate([0,0,-(D_ball/2)]){
                cylinder(h=(D_ball*2),r=((D_ball/2)-t_shell_ball)*sin(lower_ball_start_angle),
                         center=true,$fn=fn);
            };
            translate([0,0,pow(((pow(cos(lower_ball_start_angle),2)*pow(D_ball,2))/4),0.5)]){
                sphere(r=(D_ball/2)-t_shell_ball_shank,$fn=fn);
            };
            cylinder(h=D_ball*3,d=d_ball_shank-2*t_shell_ball_shank,
                     center=true,$fn=fn);
        };
    };
};