--  Prints the flight envelope limits and a climb within the cruise band
with Ada.Text_IO;
use Ada.Text_IO;

procedure Ex01_Flight_Limits is
   type Altitude_Ft is range 0 .. 60_000;
   subtype Cruise_Ft is Altitude_Ft range 20_000 .. 45_000;

   type Speed_Kt is range 0 .. 900;

   Starting_Cruising_Altitude : constant Cruise_Ft := 35_000;
   Altitude_Increase          : constant           := 1_500;
   Climbed_Altitude           : constant Cruise_Ft :=
     Starting_Cruising_Altitude + Altitude_Increase;
begin
   Put_Line ("FLIGHT LIMITS");

   Put_Line ("Altitude (ft): " & Altitude_Ft'First'Image
     & " .." & Altitude_Ft'Last'Image);

   Put_Line ("Cruise (ft): " & Cruise_Ft'First'Image
     & " .." & Cruise_Ft'Last'Image);

   Put_Line ("Speed (kt): " & Speed_Kt'First'Image
     & " .." & Speed_Kt'Last'Image);

   Put_Line ("Climb:" & Starting_Cruising_Altitude'Image
     & " ->" & Climbed_Altitude'Image);
end Ex01_Flight_Limits;
