module vector_multiplier_tb;
    // Fungerer ikke veldig bra for høyt antall vektorpar, men illustrerer hvordan det kan paralleliseres.
    // Definerer parametre
    parameter VECTOR_SIZE = 20;
    parameter ELEMENT_SIZE = 16;
    // Brukt for å generere tilfeldige vektorer å regne på
    parameter MAX_NUMBER = 64;
    parameter MIN_NUMBER = 1;
    parameter VECTOR_PAIRS = 500;
    
    // Flagg for å sjekke om utregninger stemmer, tar lang tid å printe, så unngås om mulig.
    parameter SHOW_PROGRESS = 1;

    // Definerer flagg og andre nødvendige verdier
    reg clk;
    reg rst;
    reg [VECTOR_PAIRS-1:0]trigger;

    integer pair_index;

    reg [ELEMENT_SIZE*VECTOR_SIZE-1:0] vector_a[0:VECTOR_PAIRS-1];
    reg [ELEMENT_SIZE*VECTOR_SIZE-1:0] vector_b[0:VECTOR_PAIRS-1];

    wire [ELEMENT_SIZE-1:0] dot_product [0:VECTOR_PAIRS-1];
    wire [ELEMENT_SIZE*VECTOR_SIZE-1:0] result [0:VECTOR_PAIRS-1];

    // Initialiserer hovedmodulen slik at hver modul håndterer et vektorpar
    genvar j;
    generate
        for (j = 0; j < VECTOR_PAIRS; j = j + 1) begin
            vector_multiplier #(
                .ELEMENT_SIZE(ELEMENT_SIZE),
                .VECTOR_SIZE(VECTOR_SIZE)
            ) uut (
                .clk(clk),
                .rst(rst),
                .trigger(trigger[j]),
                .vector_a(vector_a[j]),
                .vector_b(vector_b[j]),
                .result(result[j]),
                .dot_product(dot_product[j])
            );
        end
    endgenerate
    

    // Simulerer en klokkepuls
    always begin
        #5 clk = ~clk;
    end

    // Setter input verdier for modulen og kjører programmet
    initial begin
        clk = 0;
        rst = 1;
        trigger = 0;
        pair_index = 0;

        rst = 0;

        // Genererer tilfeldige vektorpar
        for (pair_index = 0; pair_index < VECTOR_PAIRS; pair_index = pair_index + 1) begin
            vector_a[pair_index] = 0;
            vector_b[pair_index] = 0;

            for (integer i = 0; i < VECTOR_SIZE; i = i + 1) begin
                vector_a[pair_index][i*ELEMENT_SIZE +: ELEMENT_SIZE] = $urandom_range(MIN_NUMBER, MAX_NUMBER);
                vector_b[pair_index][i*ELEMENT_SIZE +: ELEMENT_SIZE] = $urandom_range(MIN_NUMBER, MAX_NUMBER);
            end
        end
        $display("Finished creating");
        $display("Starting calculations");
        $display("----------------------------------------------");
        // Sender inn ett og ett vektorpar, viste seg mye mer effektivt enn å sende inn alle vektorpar samtidig.
        #10 trigger = {VECTOR_PAIRS{1'b1}};
        #10 trigger = 0;
        for (pair_index = 0; pair_index < VECTOR_PAIRS; pair_index = pair_index + 1) begin
            // Setter start-flagg for modulen

            #20
            // Skriver ut resultater
            if (SHOW_PROGRESS) begin
                $display("Vector pair: %d", pair_index + 1);
                for (integer i = 0; i < VECTOR_SIZE; i = i + 1) begin
                    $display("Element %0d: %d * %d = %d",
                    i + 1,
                    vector_a[pair_index][i*ELEMENT_SIZE +: ELEMENT_SIZE],
                    vector_b[pair_index][i*ELEMENT_SIZE +: ELEMENT_SIZE],
                    result[pair_index][i*ELEMENT_SIZE +: ELEMENT_SIZE]);
                end
                $display("Finished calculating, Dot product = %d", dot_product[pair_index]);
                $display("----------------------------------------------");
            end
        end
        $display("Finished running");
        $finish;
    end
endmodule