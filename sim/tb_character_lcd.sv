`timescale 1ns/1ps

module tb_character_lcd;

    reg clk_50mhz = 0;
    reg rst_p = 1;

    wire lcd_e;
    wire lcd_rs;
    wire lcd_rw;
    wire [7:0] lcd_data;

    reg [7:0] expected_data [0:39];
    reg expected_rs [0:39];

    integer count = 0;
    integer i;

    always #10 clk_50mhz = ~clk_50mhz;

    lab3_character_lcd #(
        .TICK_CYCLES(2),
        .POWER_TICKS(3),
        .NORMAL_WAIT_TICKS(1),
        .CLEAR_WAIT_TICKS(2)
    ) dut (
        .clk_50mhz(clk_50mhz),
        .rst_p(rst_p),
        .lcd_e(lcd_e),
        .lcd_rs(lcd_rs),
        .lcd_rw(lcd_rw),
        .lcd_data(lcd_data)
    );

    initial begin
        expected_data[0] = 8'h38;
        expected_data[1] = 8'h38;
        expected_data[2] = 8'h38;

        expected_data[3] = 8'h0c;
        expected_data[4] = 8'h06;
        expected_data[5] = 8'h01;
        expected_data[6] = 8'h80;

        expected_data[7]  = "F";
        expected_data[8]  = "P";
        expected_data[9]  = "G";
        expected_data[10] = "A";
        expected_data[11] = " ";
        expected_data[12] = "L";
        expected_data[13] = "A";
        expected_data[14] = "B";
        expected_data[15] = "3";

        for (i = 16; i <= 22; i = i + 1)
            expected_data[i] = " ";

        expected_data[23] = 8'hc0;

        expected_data[24] = "L";
        expected_data[25] = "C";
        expected_data[26] = "D";
        expected_data[27] = " ";
        expected_data[28] = "C";
        expected_data[29] = "O";
        expected_data[30] = "N";
        expected_data[31] = "T";
        expected_data[32] = "R";
        expected_data[33] = "O";
        expected_data[34] = "L";
        expected_data[35] = "L";
        expected_data[36] = "E";
        expected_data[37] = "R";
        expected_data[38] = " ";
        expected_data[39] = " ";

        for (i = 0; i < 40; i = i + 1)
            expected_rs[i] = (i >= 7 && i != 23);

        expected_rs[38] = 1;
        expected_rs[39] = 1;
    end

    always @(negedge lcd_e)
        if (!rst_p && count < 40) begin

            if (lcd_rw !== 0 ||
                lcd_rs !== expected_rs[count] ||
                lcd_data !== expected_data[count])

                $fatal(
                    1,
                    "index=%0d rs=%b data=%h",
                    count,
                    lcd_rs,
                    lcd_data
                );

            count = count + 1;

            if (count == 40) begin
                $display("LAB3_LCD_PASS bytes=%0d", count);
                $finish;
            end
        end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_character_lcd);

        repeat (3)
            @(posedge clk_50mhz);

        rst_p = 0;
    end

    initial begin
        #50000;
        $fatal(1, "timeout count=%0d", count);
    end

endmodule
