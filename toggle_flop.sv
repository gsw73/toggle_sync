module toggle_flop
(
    input logic clk,
    input logic rst_n,

    input logic sel,
    output logic pol
);

// =======================================================================
// Logic

// Register:  pol
//
// Gives a level-shift everytime a pulse occurs at the input to the module.

always_ff @( posedge clk )

    if ( !rst_n )
        pol <= 1'b0;

    else if ( sel )
        pol <= ~pol;

    else
        pol <= pol;

endmodule
