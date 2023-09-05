
clear;
clc;
%% 1. Initilize the Arduino
a = arduino('COM3', 'Uno', 'Libraries',{'Ultrasonic','ExampleLCD/LCDAddon'},'Forcebuild',true ); 

ultrasonicObj = ultrasonic(a,'D13','D12');

lcd = addon(a,'ExampleLCD/LCDAddon','RegisterSelectPin','D7','EnablePin','D6','DataPins',{'D5','D4','D3','D2'});
initializeLCD(lcd, 'Rows', 2, 'Columns', 16);

%% 2. Define Pins and Variables
BUTTON_CC = 'A4';
BUTTON_ACC = 'A3';
BUTTON_CANCEL = 'A2';
BUTTON_INC = 'A1';
BUTTON_DEC = 'A0';

speed=0;%current_speed
mode=0;%current mode
max_speed=100;%maximum_speed
min_speed=0;%minimum_speed
setspeed=0;%locked speed in adaptive cruise mode
threshold_dis=0.2;%threshold distance for ultrasonic sensor in meters
printLCD(lcd,'   ADAPTIVE  ');%Introductory message_lcd_row1
printLCD(lcd,'CRUISE CONTROL');%Introductory message_lcd_row2
pause(3);%pausing the code at this line to display the introductory message for a certain amount of time
printLCD(lcd,'Speed:0 ');%Displaying currrent speed_lcd_row1
printLCD(lcd,'Mode: NORMAL');%Displaying currrent mode_lcd_row2

%% 3. Main loop
while 1 %Main infinite loop
        clearLCD(lcd);%clears the lcd display
        printLCD(lcd,['Speed: ',num2str(speed)]);
        printLCD(lcd,'Mode: NORMAL');%mode=0 for normal mode
        while readVoltage(a,BUTTON_INC)<=2 %active_low input button(accelerator)
            if speed<=max_speed
                speed=speed+1;
                printLCD(lcd,['Speed: ',num2str(speed)]);
                printLCD(lcd,'Mode: NORMAL');
                pause(0.7);
            end
        end
        while readVoltage(a,BUTTON_DEC)<=2%active_low input button(break or decrease speed)
            if speed>0               
                speed=speed-1;
                printLCD(lcd,['Speed: ',num2str(speed)]);
                printLCD(lcd,'Mode: NORMAL');
                pause(0.2);
            end
        end
        if readVoltage(a,BUTTON_CC)<=2
            mode=1;%mode=1 for cruise mode
        end
        while mode==1
            printLCD(lcd,['Speed: ',num2str(speed)]);
            printLCD(lcd,'Mode: CC');
            while readVoltage(a,BUTTON_INC)<=2
                speed=speed+1;                
                printLCD(lcd,['Speed: ',num2str(speed)]);
                printLCD(lcd,'Mode: CC');
                pause(1);
            end
            while readVoltage(a,BUTTON_DEC)<=2
                speed=speed-1;
                printLCD(lcd,['Speed: ',num2str(speed)]);
                printLCD(lcd,'Mode: CC');
                pause(1);
            end
            if readVoltage(a,BUTTON_CANCEL)<=2%active_low input button(cancel mode)%resets the mode to 0
               mode=0;
            end
        end
        if readVoltage(a,BUTTON_ACC)<=2%active_low input button(adaptive cruise mode)
            mode=2;
            setspeed=speed;
        end
        while mode==2
            printLCD(lcd,['Speed: ',num2str(speed)]);
            printLCD(lcd,'Mode: ACC');
            %reads signal from ultasonic sensor and compares the value with threshold value
            if readDistance(ultrasonicObj)<threshold_dis && speed>-1%if value is less than threshold, speed is decreased
                speed=speed-1;
                if speed<0
                    speed=0;
                    printLCD(lcd,['Speed: ',num2str(speed)]);
                    printLCD(lcd,'Mode: ACC');
                    pause(0.5);
                    %pause((threshold_dis/readDistance(ultrasonicObj))^-2);
                else
                    printLCD(lcd,['Speed: ',num2str(speed)]);
                    printLCD(lcd,'Mode: ACC');
                    pause(0.5);
                    %pause((threshold_dis/readDistance(ultrasonicObj))^-2);
                end
            end
             %reads signal from ultasonic sensor and compares the value with threshold value
            if readDistance(ultrasonicObj)>threshold_dis%if value is greater than threshold, speed is increased
                if speed<setspeed
                    speed=speed+1;                    
                end
                printLCD(lcd,['Speed: ',num2str(speed)]);
                printLCD(lcd,'Mode: ACC');
                pause(0.5);
            end
            if readVoltage(a,BUTTON_CANCEL)<=2%active_low input button(cancel mode)%resets the mode to 0
               mode=0;
            end
        end
        %default deceleration
        if speed>0%In normal mode (mode=0), when the system is untouched, speed is decreased          
            speed=speed-1;
            pause(2);
        end
end        