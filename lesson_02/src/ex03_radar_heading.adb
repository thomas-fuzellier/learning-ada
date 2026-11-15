with Ada.Text_IO;
use Ada.Text_IO;

procedure Ex03_Radar_Heading is
   Start_Heading : constant Positive       := 10;
	Mod_Column    : constant Positive_Count := 11;
   Rem_Column    : constant Positive_Count := 21;
   Turn_1        : constant Integer        := -30;
   Turn_2        : constant Positive       := 400;
   Turn_3        : constant Integer        := -725;
begin
   Put_Line ("RADAR HEADING");
   Put_Line ("Start heading:" & Start_Heading'Image);

   Put ("Turn");
   Set_Col (Mod_Column);
   Put ("mod");
   Set_Col (Rem_Column);
   Put_Line ("rem");
   


end Ex03_Radar_Heading;