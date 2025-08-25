`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.08.2025 18:48:51
// Design Name: 
// Module Name: Washing_Machine
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module Washing_Machine(
    input clk, reset, door_close, start, filled, detergent_added, cycle_timeout, drained, spin_timeout,
    output reg door_lock, motor_on, fill_value_on, drain_value_on, done, soap_wash, water_wash
);

parameter check_door    = 3'b000;
parameter fill_water    = 3'b001;
parameter add_detergent = 3'b010;
parameter cycle         = 3'b011;
parameter drain_water   = 3'b100;
parameter spin          = 3'b101;

reg [2:0] current_state, next_state;
reg wash_phase;  // 0 = soap wash, 1 = water wash (rinse)

// Next state + Outputs
always @(*) begin
    // default values
    next_state     = current_state;
    motor_on       = 0;
    fill_value_on  = 0;
    drain_value_on = 0;
    door_lock      = 1;
    soap_wash      = 0;
    water_wash     = 0;
    done           = 0;

    case(current_state)
        check_door: begin
            if(start && door_close) next_state = fill_water;
        end
        
        fill_water: begin
            fill_value_on = 1;
            if(filled) begin
                if(wash_phase == 0) 
                    next_state = add_detergent;  // soap wash
                else 
                    next_state = cycle;          // water rinse
            end
        end

        add_detergent: begin
            if(detergent_added) next_state = cycle;
        end

        cycle: begin
            motor_on = 1;
            if(wash_phase == 0) soap_wash = 1;   // soap wash phase
            else water_wash = 1;                 // water rinse phase

            if(cycle_timeout) next_state = drain_water;
        end

        drain_water: begin
            drain_value_on = 1;
            if(drained) begin
                if(wash_phase == 0) begin
                    next_state = fill_water;   // do rinse cycle
                end else begin
                    next_state = spin;         // go to spin after rinse
                end
            end
        end

        spin: begin
            motor_on = 0;
            if(spin_timeout) begin
                next_state = check_door;
                done = 1;
            end
        end

        default: next_state = check_door;
    endcase
end

// State + wash_phase update
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        current_state <= check_door;
        wash_phase <= 0;  // start with soap wash
    end else begin
        current_state <= next_state;
        // switch to water rinse after first drain
        if(current_state == drain_water && drained && wash_phase == 0)
            wash_phase <= 1;
        else if(current_state == spin && spin_timeout)
            wash_phase <= 0;  // reset phase for next wash
    end
end

endmodule








	



