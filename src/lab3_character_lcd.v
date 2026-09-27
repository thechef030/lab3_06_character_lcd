`timescale 1ns/1ps

module lab3_character_lcd #(
    parameter integer TICK_CYCLES = 500,
    parameter integer POWER_TICKS = 2_000,
    parameter integer NORMAL_WAIT_TICKS = 4,
    parameter integer CLEAR_WAIT_TICKS = 200
) (
    input  wire       clk_50mhz,
    input  wire       rst_p,
    output reg        lcd_e,
    output reg        lcd_rs,
    output wire       lcd_rw,
    output reg [7:0]  lcd_data
);

    localparam integer TICK_WIDTH =
        (TICK_CYCLES < 2) ? 1 : $clog2(TICK_CYCLES);

    reg [TICK_WIDTH-1:0] tick_count;
    reg tick;
    reg [1:0] phase;

    reg [5:0] index;
    integer wait_count;
    integer power_count;

    reg byte_rs;
    reg [7:0] byte_data;

    assign lcd_rw = 1'b0;

    // Tick generator
    always @(posedge clk_50mhz or posedge rst_p) begin
        if (rst_p) begin
            tick_count <= 0;
            tick <= 0;
        end
        else if (tick_count == TICK_CYCLES - 1) begin
            tick_count <= 0;
            tick <= 1;
        end
        else begin
            tick_count <= tick_count + 1'b1;
            tick <= 0;
        end
    end

    // LCD command / character data
    always @* begin
        byte_rs = 1'b0;
        byte_data = 8'h00;

        case (index)
            0, 1, 2: byte_data = 8'h38;
            3: byte_data = 8'h0c;
            4: byte_data = 8'h06;
            5: byte_data = 8'h01;
            6: byte_data = 8'h80;

            7:  begin byte_rs = 1; byte_data = "F"; end
            8:  begin byte_rs = 1; byte_data = "P"; end
            9:  begin byte_rs = 1; byte_data = "G"; end
            10: begin byte_rs = 1; byte_data = "A"; end
            11: begin byte_rs = 1; byte_data = " "; end
            12: begin byte_rs = 1; byte_data = "L"; end
            13: begin byte_rs = 1; byte_data = "A"; end
            14: begin byte_rs = 1; byte_data = "B"; end
            15: begin byte_rs = 1; byte_data = "3"; end

            16,17,18,19,20,21,22:
                begin byte_rs = 1; byte_data = " "; end

            23: byte_data = 8'hc0;

            24: begin byte_rs = 1; byte_data = "L"; end
            25: begin byte_rs = 1; byte_data = "C"; end
            26: begin byte_rs = 1; byte_data = "D"; end
            27: begin byte_rs = 1; byte_data = " "; end
            28: begin byte_rs = 1; byte_data = "C"; end
            29: begin byte_rs = 1; byte_data = "O"; end
            30: begin byte_rs = 1; byte_data = "N"; end
            31: begin byte_rs = 1; byte_data = "T"; end
            32: begin byte_rs = 1; byte_data = "R"; end
            33: begin byte_rs = 1; byte_data = "O"; end
            34: begin byte_rs = 1; byte_data = "L"; end
            35: begin byte_rs = 1; byte_data = "L"; end
            36: begin byte_rs = 1; byte_data = "E"; end
            37: begin byte_rs = 1; byte_data = "R"; end
            38,39:
                begin byte_rs = 1; byte_data = " "; end

            default:
                byte_data = 8'h00;
        endcase
    end

    // LCD control sequence
    always @(posedge clk_50mhz or posedge rst_p) begin
        if (rst_p) begin
            lcd_e <= 0;
            lcd_rs <= 0;
            lcd_data <= 0;

            phase <= 0;
            index <= 0;
            wait_count <= 0;
            power_count <= 0;
        end
        else if (tick) begin
            if (power_count < POWER_TICKS) begin
                power_count <= power_count + 1;
                lcd_e <= 0;
            end
            else begin
                case (phase)
                    0: begin
                        lcd_e <= 0;
                        lcd_rs <= byte_rs;
                        lcd_data <= byte_data;
                        phase <= 1;
                    end

                    1: begin
                        lcd_e <= 1;
                        phase <= 2;
                    end

                    2: begin
                        lcd_e <= 0;

                        wait_count <=
                            (index == 5)
                            ? CLEAR_WAIT_TICKS
                            : NORMAL_WAIT_TICKS;

                        phase <= 3;
                    end

                    default: begin
                        if (wait_count > 0)
                            wait_count <= wait_count - 1;
                        else begin
                            index <= (index == 39)
                                   ? 6
                                   : index + 1'b1;

                            phase <= 0;
                        end
                    end
                endcase
            end
        end
    end

endmodule
