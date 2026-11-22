--  Prints the radar heading after each turn, using a modular heading type
with Ada.Text_IO;
use Ada.Text_IO;

procedure Ex03_Radar_Heading is
   type Heading_Deg is mod 360;

   Start_Heading : constant Heading_Deg := 10;

   Turn_1 : constant Integer := -30;
   Turn_2 : constant Integer := 400;
   Turn_3 : constant Integer := -725;

   Turn_Column       : constant Positive_Count := 6;
   Arrow_Column      : constant Positive_Count := 11;
   Normalized_Column : constant Positive_Count := 13;

   Normalized_Heading_1 : constant Heading_Deg :=
     Start_Heading + Heading_Deg'Mod (Turn_1);
   Normalized_Heading_2 : constant Heading_Deg :=
     Start_Heading + Heading_Deg'Mod (Turn_2);
   Normalized_Heading_3 : constant Heading_Deg :=
     Start_Heading + Heading_Deg'Mod (Turn_3);
begin
   Put_Line ("RADAR HEADING");

   Put_Line ("Start heading:" & Start_Heading'Image);

   Put ("Turn");
   Set_Col (Turn_Column);
   Put (Turn_1'Image);
   Set_Col (Arrow_Column);
   Put ("->");
   Set_Col (Normalized_Column);
   Put_Line (Normalized_Heading_1'Image);

   Put ("Turn");
   Set_Col (Turn_Column);
   Put (Turn_2'Image);
   Set_Col (Arrow_Column);
   Put ("->");
   Set_Col (Normalized_Column);
   Put_Line (Normalized_Heading_2'Image);

   Put ("Turn");
   Set_Col (Turn_Column);
   Put (Turn_3'Image);
   Set_Col (Arrow_Column);
   Put ("->");
   Set_Col (Normalized_Column);
   Put_Line (Normalized_Heading_3'Image);
end Ex03_Radar_Heading;
