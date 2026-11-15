--  Prints the first and last values of the predefined scalar types
with Ada.Text_IO;
use Ada.Text_IO;

procedure Ex01_Type_Limits is
   Column_First : constant Positive_Count := 13;
   Column_Last : constant Positive_Count := 27;
begin
   Put_Line ("SCALAR TYPE LIMITS");
   New_Line;

   Put ("Type");
   Set_Col (Column_First);
   Put ("First");
   Set_Col (Column_Last);
   Put_Line ("Last");

   Put ("Integer");
   Set_Col (Column_First);
   Put (Integer'First'Image);
   Set_Col (Column_Last);
   Put_Line (Integer'Last'Image);

   Put ("Natural");
   Set_Col (Column_First);
   Put (Natural'First'Image);
   Set_Col (Column_Last);
   Put_Line (Natural'Last'Image);

   Put ("Positive");
   Set_Col (Column_First);
   Put (Positive'First'Image);
   Set_Col (Column_Last);
   Put_Line (Positive'Last'Image);

   Put ("Boolean");
   Set_Col (Column_First);
   Put (Boolean'First'Image);
   Set_Col (Column_Last);
   Put_Line (Boolean'Last'Image);

   Put ("Character");
   Set_Col (Column_First);
   Put (Character'Pos (Character'First)'Image);
   Set_Col (Column_Last);
   Put_Line (Character'Pos (Character'Last)'Image);

end Ex01_Type_Limits;
