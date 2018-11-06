$fn=32; // Global fragment smoothing value.

// Notes: 
// I have tried to expose some of the more common parameters that you might need to tweak to fit the parts to your setup
// but there's still quite a lot of hardcoded values in there.
// Be aware that I tend to go quite narrow with screw holes as I like to tap them and get a good thread, you may need to 

// Options: The following variables are optional parameters
leadRodBearingType = 0; // 0 = 4 screw holes, 1 = 3 screw holes
hasZStopScrew = true; // Setting this to true will add a section to screw in screw you can use to adjust z-stop min
hasXStopMount = true; // Setting this to true will add a mount for a X-min switch
hasCableChainMount = true; // Setting this to true will add 2 holes above the motor section to attach a cable chain mount

// You can adjust the following variables if your vitamin parts and alignment don't match the defaults
linearBearingInnerRadius = 7.5; // This should match the radius of the linear bearings
linearBearingOuterRadius = 10.5; // Bearing housing wall thickness is this value minus linearBearingInnerRadius
linearBearingHeight = 25.5; // This is the height of the enclosure for the linear bearing, not neccisarily the length of the bearing itself
GapBetweenLinearBearings = 9; // A stopper will be created between the linear bearings with this height to create a gap

leadRodCouplingInnerRadius = 5.1; // Lead rod coupling inner radius. If you want to insert the shaft of your lead rod bearing, you should se this value to match
leadRodCouplingOuterRadius = 11; // Lead rod couple inner radius. Should match the total width of the lead rod bearing
leadRodCouplingHeight = 10; // 10mm seems to be a good value for this

smoothRodRadius = 4.05; // Radius of your X axis smooth rods. Go ever so slightly over to help with fit
smoothRodInsertLength = 45; // Distance into the printed part that the X axis smooth rod can go - may need altering depending on the length of your X smooth rods
distanceBetweenSmoothRods = 45; // The vertical distance between the center points of the smooth rods

beltTensionVoidHeight = 31; // Height of the void through the center of the part for the belt tensor
beltTensionVoidWidth = 10; // This value should be wide enough to house the belt or belt tensor
beltTensionVoidLength = 58; // Depth of the cavity
BeltTensionVoidVerticalOffset = 0; // The tension void will be position equally between the smooth rod holes unless offset

distanceBetweenSmoothRodAndLinearBearing = 15;
distanceBetweenLinearBearingAndLeadRod = 18; // X axis distance from the center of the linear bearing to the center of the lead rod
leadRodYaxisOffset = 0; // A positive value here will move the lead rod center away from the main body in the X axis, a negative value will be closer
leadRodScrewHoleRadius = 1.75; // Screw hole size for the lead rod bearing
leadRodScrewHoleDistance = 2.5; // Linear distance direct from screw hole center to the leadRodCouplingInnerRadius

// Calculated values
checkBodyHeight(linearBearingHeight, GapBetweenLinearBearings, smoothRodRadius, distanceBetweenSmoothRods);
bodyHeight = calculateBodyHeight(linearBearingHeight, GapBetweenLinearBearings, smoothRodRadius, distanceBetweenSmoothRods);

difference() 
{
    // Add
    mainBody(bodyHeight, leadRodCouplingHeight, linearBearingOuterRadius, leadRodCouplingOuterRadius, distanceBetweenLinearBearingAndLeadRod, distanceBetweenSmoothRodAndLinearBearing, leadRodYaxisOffset);
    
    // Sutract
    smoothRodAndBeltCavity(bodyHeight, smoothRodRadius, smoothRodInsertLength, distanceBetweenSmoothRods, beltTensionVoidHeight, beltTensionVoidWidth, beltTensionVoidLength, BeltTensionVoidVerticalOffset);
    LinearBearingSubs(bodyHeight, linearBearingInnerRadius, linearBearingOuterRadius, distanceBetweenSmoothRodAndLinearBearing);
    LeadCouplingSubs(leadRodCouplingHeight, distanceBetweenSmoothRodAndLinearBearing, linearBearingOuterRadius, leadRodCouplingInnerRadius, distanceBetweenLinearBearingAndLeadRod, leadRodYaxisOffset, leadRodScrewHoleDistance, leadRodScrewHoleRadius, leadRodBearingType);
    CableChainMount(hasCableChainMount);
}

difference()
{
    MotorScrewChannels();
    MotorScrewChannelSubtracts();
}

LinearBearingHousingExtras(bodyHeight, linearBearingOuterRadius, linearBearingInnerRadius, distanceBetweenSmoothRodAndLinearBearing);

ZStopScrewMount(hasZStopScrew, bodyHeight, linearBearingOuterRadius);
XStopSwitchMount(hasXStopMount);

// Modules and functions
module CableChainMount(hasCableChainMount)
{
    if(hasCableChainMount == true)
    {
        translate([75, 9, 0]) cylinder(h = 10, r = 1.4);
        translate([55, 9, 0]) cylinder(h = 10, r = 1.4);
    }
}

module XStopSwitchMount(hasXStopMount)
{
    if(hasXStopMount == true)
    {
        difference()
        {
            translate([-12,0,0]) cubeWithVerticalFilletsRadialWidth(17,4,25);
            translate([-7,4,12.5-5]) rotate(a=90, v=[1,0,0]) cylinder(h=4,r=1.4);
            translate([-7,4,12.5+5]) rotate(a=90, v=[1,0,0]) cylinder(h=4,r=1.4);
        }
    }
}
module ZStopScrewMount(hasZStopScrew, bodyHeight, linearBearingOuterRadius)
{
    if(hasZStopScrew == true)
    {
        difference()
        {
            translate([(linearBearingOuterRadius*2)+20-3,-6,bodyHeight-12]) cubeWithVerticalFillets(9, 10, 12, 3);
            translate([(linearBearingOuterRadius*2)+20,-6,bodyHeight-25]) rotate(a=-30, v=[0,1,0]) cube([18, 10, 12]);
            translate([(linearBearingOuterRadius*2)+23,-3,bodyHeight-11]) cylinder(h=12,r=1.4);
        }
    }
}

module MotorScrewChannels()
{
    translate([64-15.5,16,14]) rotate(a=90, v=[1,0,0]) cylinder(h=14,r=3);
    translate([64-15.5,16,14+31]) rotate(a=90, v=[1,0,0]) cylinder(h=14,r=3);
}

module MotorScrewChannelSubtracts()
{
    translate([64-15.5,18,14]) rotate(a=90, v=[1,0,0]) cylinder(h=18,r=1.65);
    translate([64-15.5,18,14+31]) rotate(a=90, v=[1,0,0]) cylinder(h=18,r=1.65);
}

module LinearBearingHousingExtras(bodyHeight, linearBearingOuterRadius, linearBearingInnerRadius, linearYOffset) 
{
    linearBearingYPos = 9 - linearYOffset;
    linearBearingStopperYPos = linearBearingYPos + linearBearingInnerRadius;
    translate([linearBearingOuterRadius+20,linearBearingYPos,0]) rotate(a=15, v=[0,0,1]) translate([0,-linearBearingOuterRadius+1.5,0]) cylinder(h=bodyHeight,r=1.5);
    translate([linearBearingOuterRadius+20,linearBearingYPos,0]) rotate(a=-15, v=[0,0,1]) translate([0,-linearBearingOuterRadius+1.5,0]) cylinder(h=bodyHeight,r=1.5);
    translate([linearBearingOuterRadius+20, linearBearingStopperYPos, bodyHeight/2]) cube([linearBearingOuterRadius*2, 3, 9], center = true);
}

module mainBody(height, leadHeight, linearRadius, leadRadius, linearLeadDist, linearYOffset, leadRodYaxisOffset) 
{
    // Main body
    cubeWithVerticalFillets(55, 18, height, 3);
    translate([48, 0, 0]) cubeWithVerticalFillets(37, 18, 22, 3);
    
    // Linear bearing housing
    linearBearingYPos = 9-linearYOffset;
    translate([linearRadius+20,linearBearingYPos,0]) cylinder(h=height,r=linearRadius);
    translate([20,linearBearingYPos,0]) cube([linearRadius*2, abs(linearBearingYPos), height]);
    translate([18,-2,0]) cube([2,2,height]);
    translate([20 + (linearRadius*2),-2,0]) cube([2,2,height]);
    
    // Lead rod bearing housing
    translate([linearRadius + 20 - linearLeadDist, linearBearingYPos + leadRodYaxisOffset, 0]) cylinder(h=leadHeight,r=leadRadius);
}

module LinearBearingSubs(height, linearInnerRadius, linearOuterRadius, yOffset)
{
    linearBearingYPos = 9 - yOffset;
    translate([linearOuterRadius + 20,linearBearingYPos,0]) cylinder(h=height,r=linearInnerRadius);
    translate([22 + (linearOuterRadius*2),-2,0]) cylinder(h=height,r=2);
    translate([18,-2,10]) cylinder(h=height-10,r=2);
    translate([linearOuterRadius+20, linearBearingYPos,height/2]) rotate(a=-15, v=[0,0,1]) translate([1.5,-linearOuterRadius+1.5,0]) cube([3,4,height], center = true);
    translate([linearOuterRadius+20, linearBearingYPos,height/2]) rotate(a=15, v=[0,0,1]) translate([-1.5,-linearOuterRadius+1.5,0]) cube([3,4,height], center = true);
}

module LeadCouplingSubs(height, yOffset, linearBearingOuterRadius, leadRodCouplingInnerRadius, linearLeadDist, leadRodYaxisOffset, leadRodScrewHoleDistance, leadRodScrewHoleRadius, leadRodBearingType)
{
	leadCouplingXPos = linearBearingOuterRadius + 20 - linearLeadDist;
    leadCouplingYPos = 9 - yOffset + leadRodYaxisOffset;
    translate([leadCouplingXPos, leadCouplingYPos, 0]) cylinder(h = height, r = leadRodCouplingInnerRadius);
    
    if (leadRodBearingType == 0)
    {
        // Brass type bearing with 4 screw holes
        //Screw Holes
        translate([leadCouplingXPos, leadCouplingYPos, 0]) rotate(a=45,v=[0,0,1]) translate([0,leadRodCouplingInnerRadius + leadRodScrewHoleDistance,0]) cylinder(h = height,r = leadRodScrewHoleRadius);
        translate([leadCouplingXPos, leadCouplingYPos, 0]) rotate(a=135,v=[0,0,1]) translate([0,leadRodCouplingInnerRadius + leadRodScrewHoleDistance,0]) cylinder(h = height,r = leadRodScrewHoleRadius);
        translate([leadCouplingXPos, leadCouplingYPos, 0]) rotate(a=225,v=[0,0,1]) translate([0,leadRodCouplingInnerRadius + leadRodScrewHoleDistance,0]) cylinder(h = height,r = leadRodScrewHoleRadius);
        translate([leadCouplingXPos, leadCouplingYPos, 0]) rotate(a=315,v=[0,0,1]) translate([0,leadRodCouplingInnerRadius + leadRodScrewHoleDistance,0]) cylinder(h = height,r = leadRodScrewHoleRadius);
        
        //Screw voids
        translate([leadCouplingXPos, leadCouplingYPos, height]) rotate(a=45,v=[0,0,1]) translate([0,leadRodCouplingInnerRadius + leadRodScrewHoleDistance,0]) cylinder(h=7,r=3.1);
        translate([leadCouplingXPos, leadCouplingYPos, height+7]) rotate(a=45,v=[0,0,1]) translate([0,leadRodCouplingInnerRadius + leadRodScrewHoleDistance]) sphere(r=3.1);
        translate([leadCouplingXPos, leadCouplingYPos, height]) rotate(a=315,v=[0,0,1]) translate([0, leadRodCouplingInnerRadius + leadRodScrewHoleDistance, 0]) cylinder(h=7,r=3.1);
        translate([leadCouplingXPos, leadCouplingYPos, height+7]) rotate(a=315,v=[0,0,1]) translate([0, leadRodCouplingInnerRadius + leadRodScrewHoleDistance, 0]) sphere(r=3.1);
    } 
    else if (leadRodBearingType == 1)
    {
        // Plastic type bearing with 3 screw holes
        //Screw Holes
        translate([leadRodCouplingOuterRadius + 20 - linearLeadDist, leadCouplingYPos, 0]) rotate(a=-45,v=[0,0,1]) translate([0,leadRodCouplingInnerRadius + leadRodScrewHoleDistance,0]) cylinder(h = height,r = leadRodScrewHoleRadius);
        translate([leadRodCouplingOuterRadius + 20 - linearLeadDist, leadCouplingYPos, 0]) rotate(a=-165,v=[0,0,1]) translate([0,leadRodCouplingInnerRadius + leadRodScrewHoleDistance,0]) cylinder(h = height,r = leadRodScrewHoleRadius);
        translate([leadRodCouplingOuterRadius + 20 - linearLeadDist, leadCouplingYPos, 0]) rotate(a=-285,v=[0,0,1]) translate([0,leadRodCouplingInnerRadius + leadRodScrewHoleDistance,0]) cylinder(h = height,r = leadRodScrewHoleRadius);
        
        //Screw void
        translate([leadRodCouplingOuterRadius + 20 - linearLeadDist, leadCouplingYPos, height]) rotate(a=-45,v=[0,0,1]) translate([0,leadRodCouplingInnerRadius + leadRodScrewHoleDistance,0]) cylinder(h=7,r=3.1);
        translate([leadRodCouplingOuterRadius + 20 - linearLeadDist, leadCouplingYPos, height+7]) rotate(a=-45,v=[0,0,1]) translate([0,leadRodCouplingInnerRadius + leadRodScrewHoleDistance]) sphere(r=3.1);
    }
}

module smoothRodAndBeltCavity(bodyHeight, smoothRodRadius, smoothRodInsertLength, distanceBetweenSmoothRods, beltTensionVoidHeight, beltTensionVoidWidth, beltTensionVoidLength, BeltTensionVoidVerticalOffset) 
{   
    // Smooth rod cavity
    translate([0, 9, (bodyHeight/2)-(distanceBetweenSmoothRods/2)]) rotate(a=90, v=[0,1,0]) cylinder(h = smoothRodInsertLength,r = smoothRodRadius);
    translate([0, 9, (bodyHeight/2)+(distanceBetweenSmoothRods/2)]) rotate(a=90, v=[0,1,0]) cylinder(h = smoothRodInsertLength,r = smoothRodRadius);
    
    // Belt Cavity
    translate([0, 4, ((bodyHeight/2) - (beltTensionVoidHeight/2))]) cubeWithXHorizontalFillets(beltTensionVoidLength, beltTensionVoidWidth, beltTensionVoidHeight, 8);
    
    translate([64, 18, bodyHeight/2]) rotate(a=90, v=[1,0,0]) hexagonWithFillets(18, 35/2, 4);
    translate([64-15.5,18,14]) rotate(a=90, v=[1,0,0]) cylinder(h=18,r=1.65);
    translate([64-15.5,18,14+31]) rotate(a=90, v=[1,0,0]) cylinder(h=18,r=1.65);
    translate([64+15.5,18,14]) rotate(a=90, v=[1,0,0]) cylinder(h=18,r=1.65);
    
    // Motor screw recess
    translate([64-15.5,2,14]) rotate(a=90, v=[1,0,0]) cylinder(h=2,r=3);
    translate([64-15.5,2,14+31]) rotate(a=90, v=[1,0,0]) cylinder(h=2,r=3);
    translate([64+15.5,2,14]) rotate(a=90, v=[1,0,0]) cylinder(h=2,r=3);
}

module cubeWithVerticalFilletsRadialWidth(length, width, height)
{
    hull()
    {
        translate([width/2, width/2 , 0]) cylinder(d=width,h=height);
        translate([length - (width/2), width/2, 0]) cylinder(d=width,h=height);
    } 
}

module cubeWithVerticalFillets(length, width, height, radius) {
    diameter = radius * 2;
    translate([radius, radius, 0]) {
        minkowski() {
            cube([length-diameter, width-diameter, height/2]);
            cylinder(r=radius,h=height/2);
        } 
    }
}

module cubeWithXHorizontalFillets(length, width, height, radius) {
    diameter = radius * 2;
    translate([0, radius/2, radius/2]) {
        minkowski() {
            cube([length/2, width-radius, height-radius]);
            rotate(a=90,v=[0,1,0]) cylinder(r=radius/2,h=length/2);
        } 
    }
}

module hexagonWithFillets(height, radius, filletRadius)
{
    hull() {
        rotate(a=60, v=[0,0,1]) translate([radius-filletRadius,0,0]) cylinder(h=height,r=filletRadius);
        rotate(a=120, v=[0,0,1]) translate([radius-filletRadius,0,0]) cylinder(h=height,r=filletRadius);
        rotate(a=180, v=[0,0,1]) translate([radius-filletRadius,0,0]) cylinder(h=height,r=filletRadius);
        rotate(a=240, v=[0,0,1]) translate([radius-filletRadius,0,0]) cylinder(h=height,r=filletRadius);
        rotate(a=300, v=[0,0,1]) translate([radius-filletRadius,0,0]) cylinder(h=height,r=filletRadius);
        rotate(a=360, v=[0,0,1]) translate([radius-filletRadius,0,0]) cylinder(h=height,r=filletRadius);
    }
}

function calculateBodyHeight(linearBearingHeight, GapBetweenLinearBearings) = (linearBearingHeight*2) + GapBetweenLinearBearings;

module checkBodyHeight(linearBearingHeight, GapBetweenLinearBearings, smoothRodRadius, distanceBetweenSmoothRods) {
    linearBearingBodyHeight = ((linearBearingHeight*2) + GapBetweenLinearBearings);
    smoothRodBodyHeight = ((smoothRodRadius*2) + distanceBetweenSmoothRods + 6);
    if(linearBearingBodyHeight < smoothRodBodyHeight) {
        echo(str("<font color=\"red\"><b><br>Warning: Body height calculated from linear bearing values is shorter than height calculated from smooth rod values<br>linearBearingBodyHeight=",linearBearingBodyHeight,"<br>smoothRodBodyHeight=",smoothRodBodyHeight,"<br></b></font>"));
    }
}



