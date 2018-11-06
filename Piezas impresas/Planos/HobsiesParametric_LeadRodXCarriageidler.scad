$fn=32; // Global fragment smoothing value.

// Notes: 
// I have tried to expose some of the more common parameters that you might need to tweak to fit the parts to your setup
// but there's still quite a lot of hardcoded values in there.
// Be aware that I tend to go quite narrow with screw holes as I like to tap them and get a good thread, you may need to 

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
leadRodBearingType = 0; // 0 = 4 screw holes, 1 = 3 screw holes
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
}

LinearBearingHousingExtras(bodyHeight, linearBearingOuterRadius, linearBearingInnerRadius, distanceBetweenSmoothRodAndLinearBearing);

module LinearBearingHousingExtras(bodyHeight, linearBearingOuterRadius, linearBearingInnerRadius, linearYOffset) 
{
    linearBearingYPos = 9-linearYOffset;
    linearBearingStopperYPos = linearBearingYPos + linearBearingInnerRadius;
    translate([linearBearingOuterRadius+5,linearBearingYPos,0]) rotate(a=15, v=[0,0,1]) translate([0,-linearBearingOuterRadius+1.5,0]) cylinder(h=bodyHeight,r=1.5);
    translate([linearBearingOuterRadius+5,linearBearingYPos,0]) rotate(a=-15, v=[0,0,1]) translate([0,-linearBearingOuterRadius+1.5,0]) cylinder(h=bodyHeight,r=1.5);
    translate([linearBearingOuterRadius+5, linearBearingStopperYPos, bodyHeight/2]) cube([linearBearingOuterRadius*2, 3, 9], center = true);
}

module mainBody(height, leadHeight, linearRadius, leadRadius, linearLeadDist, linearYOffset, leadRodYaxisOffset) {
    cubeWithVerticalFillets(50, 18, height, 3);
    
    // Linear bearing housing
    linearBearingYPos = 9-linearYOffset;
    translate([linearRadius+5,linearBearingYPos,0]) cylinder(h=height,r=linearRadius);
    translate([5,linearBearingYPos,0]) cube([linearRadius*2, abs(linearBearingYPos), height]);
    
    // Lead rod bearing housing
    translate([linearRadius+5+linearLeadDist, linearBearingYPos + leadRodYaxisOffset, 0]) cylinder(h=leadHeight,r=leadRadius);
    translate([3,-2,0]) cube([2,2,height]);
    translate([5+(linearRadius*2),-2,0]) cube([2,2,height]);
}

module LinearBearingSubs(height, linearInnerRadius, linearOuterRadius, yOffset)
{
    linearBearingYPos = 9 - yOffset;
    translate([linearOuterRadius+5,linearBearingYPos,0]) cylinder(h=height,r=linearInnerRadius);
    translate([7+(linearOuterRadius*2),-2,10]) cylinder(h=height-10,r=2);
    translate([3,-2,0]) cylinder(h=height,r=2);
    translate([linearOuterRadius+5, linearBearingYPos,height/2]) rotate(a=-15, v=[0,0,1]) translate([1.5,-linearOuterRadius+1.5,0]) cube([3,4,height], center = true);
    translate([linearOuterRadius+5, linearBearingYPos,height/2]) rotate(a=15, v=[0,0,1]) translate([-1.5,-linearOuterRadius+1.5,0]) cube([3,4,height], center = true);
}

module LeadCouplingSubs(height, yOffset, linearBearingOuterRadius, leadRodCouplingInnerRadius, linearLeadDist, leadRodYaxisOffset, leadRodScrewHoleDistance, leadRodScrewHoleRadius, leadRodBearingType)
{
	leadCouplingXPos = linearBearingOuterRadius + 5 + linearLeadDist;
    leadCouplingYPos = 9 - yOffset + leadRodYaxisOffset;
    #translate([leadCouplingXPos, leadCouplingYPos, 0]) cylinder(h = height, r = leadRodCouplingInnerRadius);
    
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
        translate([leadCouplingXPos, leadCouplingYPos, 0]) rotate(a=45,v=[0,0,1]) translate([0,leadRodCouplingInnerRadius + leadRodScrewHoleDistance,0]) cylinder(h = height,r = leadRodScrewHoleRadius);
        translate([leadCouplingXPos, leadCouplingYPos, 0]) rotate(a=165,v=[0,0,1]) translate([0,leadRodCouplingInnerRadius + leadRodScrewHoleDistance,0]) cylinder(h = height,r = leadRodScrewHoleRadius);
        translate([leadCouplingXPos, leadCouplingYPos, 0]) rotate(a=285,v=[0,0,1]) translate([0,leadRodCouplingInnerRadius + leadRodScrewHoleDistance,0]) cylinder(h = height,r = leadRodScrewHoleRadius);
        
        //Screw void
        translate([leadCouplingXPos, leadCouplingYPos, height]) rotate(a=45,v=[0,0,1]) translate([0,leadRodCouplingInnerRadius + leadRodScrewHoleDistance,0]) cylinder(h=7,r=3.1);
        translate([leadCouplingXPos, leadCouplingYPos, height+7]) rotate(a=45,v=[0,0,1]) translate([0,leadRodCouplingInnerRadius + leadRodScrewHoleDistance]) sphere(r=3.1);
    }
        
}

module smoothRodAndBeltCavity(bodyHeight, smoothRodRadius, smoothRodInsertLength, distanceBetweenSmoothRods, beltTensionVoidHeight, beltTensionVoidWidth, beltTensionVoidLength, BeltTensionVoidVerticalOffset) 
{   
    // Smooth rod cavity
    echo((bodyHeight/2)-(distanceBetweenSmoothRods/2));
    echo((bodyHeight/2)+(distanceBetweenSmoothRods/2));
    translate([5, 9, (bodyHeight/2)-(distanceBetweenSmoothRods/2)]) rotate(a=90, v=[0,1,0]) cylinder(h = smoothRodInsertLength,r = smoothRodRadius);
    translate([5, 9, (bodyHeight/2)+(distanceBetweenSmoothRods/2)]) rotate(a=90, v=[0,1,0]) cylinder(h = smoothRodInsertLength,r = smoothRodRadius);
    
    // Belt Cavity
    translate([5, 4, ((bodyHeight/2) - (beltTensionVoidHeight/2))]) cubeWithXHorizontalFillets(smoothRodInsertLength, beltTensionVoidWidth, beltTensionVoidHeight, 8);
    translate([0,9,30]) rotate(a=90,v=[0,1,0]) cylinder(h=1.5,r=3.5);
    translate([0,9,30]) rotate(a=90,v=[0,1,0]) cylinder(h=5,r=2.1);
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

function calculateBodyHeight(linearBearingHeight, GapBetweenLinearBearings) = (linearBearingHeight*2) + GapBetweenLinearBearings;

module checkBodyHeight(linearBearingHeight, GapBetweenLinearBearings, smoothRodRadius, distanceBetweenSmoothRods) {
    linearBearingBodyHeight = ((linearBearingHeight*2) + GapBetweenLinearBearings);
    smoothRodBodyHeight = ((smoothRodRadius*2) + distanceBetweenSmoothRods + 6);
    if(linearBearingBodyHeight < smoothRodBodyHeight) {
        echo(str("<font color=\"red\"><b><br>Warning: Body height calculated from linear bearing values is shorter than height calculated from smooth rod values<br>linearBearingBodyHeight=",linearBearingBodyHeight,"<br>smoothRodBodyHeight=",smoothRodBodyHeight,"<br></b></font>"));
    }
}



