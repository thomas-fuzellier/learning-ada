--  Checks a sensor reading against its valid range and alarm threshold
with Ada.Text_IO;
use Ada.Text_IO;

procedure Ex04_Sensor_Check is
   First_Sensor    : constant Character := 'A';
   Current_Sensor  : constant Character := 'C';
   Raw_Reading     : constant String    := "  42";
   Reading         : constant Integer   := Integer'Value (Raw_Reading);
   Max_Range       : constant Positive  := 100;
   Min_Range       : constant Natural   := 0;
   Alarm_Threshold : constant Positive  := 80;
   In_Range        : constant Boolean   :=
      Reading >= Min_Range and then Reading <= Max_Range;
   Alarm           : constant Boolean   :=
      Reading < Min_Range or else Reading > Alarm_Threshold;
begin
   Put_Line ("SENSOR CHECK");

   Put_Line ("Sensor: " & Current_Sensor);
   Put_Line ("Sensor number:" & Integer'Image
      (Character'Pos (Current_Sensor) - Character'Pos (First_Sensor) + 1));

   Put_Line ("Next sensor: " & Character'Succ (Current_Sensor));
   Put_Line ("Reading:" & Reading'Image);

   Put_Line ("In range: " & In_Range'Image);

   Put_Line ("Alarm: " & Alarm'Image);

end Ex04_Sensor_Check;
