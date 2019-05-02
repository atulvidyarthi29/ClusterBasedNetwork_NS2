# <http://wushoupong.googlepages.com/nsg>

#===================================
#     Simulation parameters setup
#===================================
set val(chan)   Channel/WirelessChannel    ;# channel type
set val(prop)   Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)  Phy/WirelessPhy            ;# network interface type
set val(mac)    Mac/802_11                 ;# MAC type
set val(ifq)    Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)     LL                         ;# link layer type
set val(ant)    Antenna/OmniAntenna        ;# antenna model
set val(ifqlen) 50                         ;# max packet in ifq
set val(nn)     17                         ;# number of mobilenodes
set val(rp)     DSDV                       ;# routing protocol
set val(x)      771                      ;# X dimension of topography
set val(y)      100                      ;# Y dimension of topography
set val(stop)   20.0                         ;# time of simulation end

#===================================
#        Initialization        
#===================================
#Create a ns simulator
set ns [new Simulator]

#Setup topography object
set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)

#Open the NS trace file
set tracefile [open out.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open out.nam w]
$ns namtrace-all $namfile
$ns namtrace-all-wireless $namfile $val(x) $val(y)
set chan [new $val(chan)];#Create wireless channel

#===================================
#     Mobile node parameter setup
#===================================
$ns node-config -adhocRouting  $val(rp) \
                -llType        $val(ll) \
                -macType       $val(mac) \
                -ifqType       $val(ifq) \
                -ifqLen        $val(ifqlen) \
                -antType       $val(ant) \
                -propType      $val(prop) \
                -phyType       $val(netif) \
                -channel       $chan \
                -topoInstance  $topo \
                -agentTrace    ON \
                -routerTrace   ON \
                -macTrace      ON \
                -movementTrace ON

$ns node-config -energyModel EnergyModel \
		-initialEnergy 1 \
		-txpPower 0.1 \
		-rxPower 0.0 \
		-idlePower 0.0 \
		-sensePower 0.00 \

#===================================
#        Nodes Definition        
#===================================

#Create 17 nodes
$ns node-config -initialEnergy 1
set n0 [$ns node]
$n0 set X_ 0
$n0 set Y_ 600
$n0 set Z_ 0.0
$ns initial_node_pos $n0 20
set eng0 [$n0 energy]

$ns node-config -initialEnergy 1
set n1 [$ns node]
$n1 set X_ 200
$n1 set Y_ 600
$n1 set Z_ 0.0
$ns initial_node_pos $n1 20
set eng1 [$n1 energy]

$ns node-config -initialEnergy 1
set n2 [$ns node]
$n2 set X_ 400
$n2 set Y_ 600
$n2 set Z_ 0.0
$ns initial_node_pos $n2 20
set eng2 [$n2 energy]

$ns node-config -initialEnergy 1
set n3 [$ns node]
$n3 set X_ 600
$n3 set Y_ 600
$n3 set Z_ 0.0
$ns initial_node_pos $n3 20
set eng3 [$n3 energy]

$ns node-config -initialEnergy 1
set n4 [$ns node]
$n4 set X_ 0
$n4 set Y_ 400
$n4 set Z_ 0.0
$ns initial_node_pos $n4 20
set eng4 [$n4 energy]

$ns node-config -initialEnergy 1
set n5 [$ns node]
$n5 set X_ 200
$n5 set Y_ 400
$n5 set Z_ 0.0
$ns initial_node_pos $n5 20
set eng5 [$n5 energy]

$ns node-config -initialEnergy 15
# cluster head
set n6 [$ns node]
$n6 set X_ 400
$n6 set Y_ 400
$n6 set Z_ 0.0
$ns initial_node_pos $n6 20
set eng6 [$n6 energy]

$ns node-config -initialEnergy 1
set n7 [$ns node]
$n7 set X_ 600
$n7 set Y_ 400
$n7 set Z_ 0.0
$ns initial_node_pos $n7 20
set eng7 [$n7 energy]

$ns node-config -initialEnergy 1
set n8 [$ns node]
$n8 set X_ 0
$n8 set Y_ 200
$n8 set Z_ 0.0
$ns initial_node_pos $n8 20
set eng8 [$n8 energy]

$ns node-config -initialEnergy 1
set n9 [$ns node]
$n9 set X_ 200
$n9 set Y_ 200
$n9 set Z_ 0.0
$ns initial_node_pos $n9 20
set eng9 [$n9 energy]

$ns node-config -initialEnergy 1
set n10 [$ns node]
$n10 set X_ 400
$n10 set Y_ 200
$n10 set Z_ 0.0
$ns initial_node_pos $n10 20
set eng10 [$n10 energy]

$ns node-config -initialEnergy 1
set n11 [$ns node]
$n11 set X_ 600
$n11 set Y_ 200
$n11 set Z_ 0.0
$ns initial_node_pos $n11 20
set eng11 [$n11 energy]

$ns node-config -initialEnergy 1
set n12 [$ns node]
$n12 set X_ 0
$n12 set Y_ 0
$n12 set Z_ 0.0
$ns initial_node_pos $n12 20
set eng12 [$n12 energy]

$ns node-config -initialEnergy 1
set n13 [$ns node]
$n13 set X_ 200
$n13 set Y_ 0
$n13 set Z_ 0.0
$ns initial_node_pos $n13 20
set eng13 [$n13 energy]

$ns node-config -initialEnergy 1
set n14 [$ns node]
$n14 set X_ 400
$n14 set Y_ 0
$n14 set Z_ 0.0
$ns initial_node_pos $n14 20
set eng14 [$n14 energy]

$ns node-config -initialEnergy 1
set n15 [$ns node]
$n15 set X_ 600
$n15 set Y_ 0
$n15 set Z_ 0.0
$ns initial_node_pos $n15 20
set eng15 [$n15 energy]

#base station
$ns node-config -initialEnergy 1
set n16 [$ns node]
$n16 set X_ 300
$n16 set Y_ 800
$n16 set Z_ 0.0
$ns initial_node_pos $n16 20
set eng16 [$n16 energy]

#===================================
#        Functions
#===================================


proc tr_energyloss {k dist} {
    set total [expr $k* pow(10,-12) + $k* pow($dist,2) *13* pow(10,-16) * exp(0.0203*$dist) ]
    return $total
}

proc rcv_energyloss {k} {
    set total [expr $k*pow(10,-12) ]
    return $total
}

#===================================
#        Agents Definition        
#===================================
#Setup a TCP connection
set tcp0 [new Agent/TCP]
$ns attach-agent $n12 $tcp0
set sink26 [new Agent/TCPSink]
$ns attach-agent $n6 $sink26
$ns connect $tcp0 $sink26
$tcp0 set packetSize_ 1500

#Setup a TCP connection
set tcp1 [new Agent/TCP]
$ns attach-agent $n8 $tcp1
set sink22 [new Agent/TCPSink]
$ns attach-agent $n6 $sink22
$ns connect $tcp1 $sink22
$tcp1 set packetSize_ 1500

#Setup a TCP connection
set tcp2 [new Agent/TCP]
$ns attach-agent $n4 $tcp2
set sink19 [new Agent/TCPSink]
$ns attach-agent $n6 $sink19
$ns connect $tcp2 $sink19
$tcp2 set packetSize_ 1500

#Setup a TCP connection
set tcp3 [new Agent/TCP]
$ns attach-agent $n0 $tcp3
set sink15 [new Agent/TCPSink]
$ns attach-agent $n6 $sink15
$ns connect $tcp3 $sink15
$tcp3 set packetSize_ 1500

#Setup a TCP connection
set tcp4 [new Agent/TCP]
$ns attach-agent $n1 $tcp4
set sink16 [new Agent/TCPSink]
$ns attach-agent $n6 $sink16
$ns connect $tcp4 $sink16
$tcp4 set packetSize_ 1500

#Setup a TCP connection
set tcp5 [new Agent/TCP]
$ns attach-agent $n2 $tcp5
set sink17 [new Agent/TCPSink]
$ns attach-agent $n6 $sink17
$ns connect $tcp5 $sink17
$tcp5 set packetSize_ 1500

#Setup a TCP connection
set tcp6 [new Agent/TCP]
$ns attach-agent $n3 $tcp6
set sink18 [new Agent/TCPSink]
$ns attach-agent $n6 $sink18
$ns connect $tcp6 $sink18
$tcp6 set packetSize_ 1500

#Setup a TCP connection
set tcp7 [new Agent/TCP]
$ns attach-agent $n7 $tcp7
set sink20 [new Agent/TCPSink]
$ns attach-agent $n6 $sink20
$ns connect $tcp7 $sink20
$tcp7 set packetSize_ 1500

#Setup a TCP connection
set tcp8 [new Agent/TCP]
$ns attach-agent $n11 $tcp8
set sink25 [new Agent/TCPSink]
$ns attach-agent $n6 $sink25
$ns connect $tcp8 $sink25
$tcp8 set packetSize_ 1500

#Setup a TCP connection
set tcp9 [new Agent/TCP]
$ns attach-agent $n15 $tcp9
set sink29 [new Agent/TCPSink]
$ns attach-agent $n6 $sink29
$ns connect $tcp9 $sink29
$tcp9 set packetSize_ 1500

#Setup a TCP connection
set tcp10 [new Agent/TCP]
$ns attach-agent $n14 $tcp10
set sink28 [new Agent/TCPSink]
$ns attach-agent $n6 $sink28
$ns connect $tcp10 $sink28
$tcp10 set packetSize_ 1500

#Setup a TCP connection
set tcp11 [new Agent/TCP]
$ns attach-agent $n13 $tcp11
set sink27 [new Agent/TCPSink]
$ns attach-agent $n6 $sink27
$ns connect $tcp11 $sink27
$tcp11 set packetSize_ 1500

#Setup a TCP connection
set tcp12 [new Agent/TCP]
$ns attach-agent $n9 $tcp12
set sink23 [new Agent/TCPSink]
$ns attach-agent $n6 $sink23
$ns connect $tcp12 $sink23
$tcp12 set packetSize_ 1500

#Setup a TCP connection
set tcp13 [new Agent/TCP]
$ns attach-agent $n5 $tcp13
set sink21 [new Agent/TCPSink]
$ns attach-agent $n6 $sink21
$ns connect $tcp13 $sink21
$tcp13 set packetSize_ 1500

#Setup a TCP connection
set tcp14 [new Agent/TCP]
$ns attach-agent $n10 $tcp14
set sink24 [new Agent/TCPSink]
$ns attach-agent $n6 $sink24
$ns connect $tcp14 $sink24
$tcp14 set packetSize_ 1500

#Setup a TCP connection
set tcp31 [new Agent/TCP]
$ns attach-agent $n6 $tcp31
set sink30 [new Agent/TCPSink]
$ns attach-agent $n16 $sink30
$ns connect $tcp31 $sink30
$tcp31 set packetSize_ 1500




#===================================
#        Applications Definition        
#===================================

set k [expr 10*8*pow(10,6)] 
#data rate
set d_nodes_plus 33.33		
set d_nodes_cross [ expr 33.33 * 1.41 ]
set d_nodes_intermediate_cross [ expr 33.33 * 2.24 ]  
set d_base_station 100

set count 0

while { $eng0 > 0 || $eng1 > 0 || $eng2 > 0 || $eng3 > 0 || $eng4 > 0 || $eng5 > 0 || $eng7 > 0 || $eng8 > 0 || $eng9 > 0 || $eng10 > 0 || $eng11 > 0 || $eng12 > 0 || $eng13 > 0 || $eng14 > 0 || $eng15 > 0 && $eng6 > 0 } {

    #Setup a FTP Application over TCP connection
    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $tcp3
    $ns at 1.0 "$ftp0 start"
    $ns at 2.0 "$ftp0 stop"
    set loss0 [ tr_energyloss $k  $d_nodes_intermediate_cross ]
	set eng0 [expr $eng0 - $loss0 ]

    #Setup a FTP Application over TCP connection
    set ftp1 [new Application/FTP]
    $ftp1 attach-agent $tcp4
    $ns at 2.0 "$ftp1 start"
    $ns at 3.0 "$ftp1 stop"
    set loss1 [ tr_energyloss $k  $d_nodes_cross ]
	set eng1 [expr $eng1 - $loss1 ]

    #Setup a FTP Application over TCP connection
    set ftp2 [new Application/FTP]
    $ftp2 attach-agent $tcp5
    $ns at 3.0 "$ftp2 start"
    $ns at 4.0 "$ftp2 stop"
    set loss2 [ tr_energyloss $k  $d_nodes_plus ]
	set eng2 [expr $eng2 - $loss2 ]

    #Setup a FTP Application over TCP connection
    set ftp3 [new Application/FTP]
    $ftp3 attach-agent $tcp6
    $ns at 4.0 "$ftp3 start"
    $ns at 5.0 "$ftp3 stop"
    set loss3 [ tr_energyloss $k  $d_nodes_cross ]
	set eng3 [expr $eng3 - $loss3 ]

    #Setup a FTP Application over TCP connection
    set ftp4 [new Application/FTP]
    $ftp4 attach-agent $tcp2
    $ns at 5.0 "$ftp4 start"
    $ns at 6.0 "$ftp4 stop"
	set d [ expr  $d_nodes_plus*2 ]
    set loss4 [ tr_energyloss $k  $d ]
	set eng4 [expr $eng4 - $loss4 ]

    #Setup a FTP Application over TCP connection
    set ftp5 [new Application/FTP]
    $ftp5 attach-agent $tcp13
    $ns at 6.0 "$ftp5 start"
    $ns at 7.0 "$ftp5 stop"
    set loss5 [ tr_energyloss $k  $d_nodes_plus ]
	set eng5 [expr $eng5 - $loss5 ]

    #Setup a FTP Application over TCP connection
    set ftp6 [new Application/FTP]
    $ftp6 attach-agent $tcp7
    $ns at 7.0 "$ftp6 start"
    $ns at 8.0 "$ftp6 stop"
    set loss7 [ tr_energyloss $k  $d_nodes_plus ]
	set eng7 [expr $eng7 - $loss7 ]

    #Setup a FTP Application over TCP connection
    set ftp7 [new Application/FTP]
    $ftp7 attach-agent $tcp1
    $ns at 8.0 "$ftp7 start"
    $ns at 9.0 "$ftp7 stop"
    set loss8 [ tr_energyloss $k  $d_nodes_intermediate_cross ]
	set eng8 [expr $eng8 - $loss8 ]

    #Setup a FTP Application over TCP connection
    set ftp8 [new Application/FTP]
    $ftp8 attach-agent $tcp12
    $ns at 9.0 "$ftp8 start"
    $ns at 10.0 "$ftp8 stop"
    set loss9 [ tr_energyloss $k  $d_nodes_cross ]
	set eng9 [expr $eng9 - $loss9 ]

    #Setup a FTP Application over TCP connection
    set ftp9 [new Application/FTP]
    $ftp9 attach-agent $tcp14
    $ns at 10.0 "$ftp9 start"
    $ns at 11.0 "$ftp9 stop"
    set loss10 [ tr_energyloss $k  $d_nodes_plus ]
	set eng10 [expr $eng10 - $loss10 ]

    #Setup a FTP Application over TCP connection
    set ftp10 [new Application/FTP]
    $ftp10 attach-agent $tcp8
    $ns at 11.0 "$ftp10 start"
    $ns at 12.0 "$ftp10 stop"
    set loss11 [ tr_energyloss $k  $d_nodes_cross ]
	set eng11 [expr $eng11 - $loss11 ]

    #Setup a FTP Application over TCP connection
    set ftp11 [new Application/FTP]
    $ftp11 attach-agent $tcp0
    $ns at 12.0 "$ftp11 start"
    $ns at 13.0 "$ftp11 stop"
	set d [ expr $d_nodes_cross*2 ]
    set loss12 [ tr_energyloss $k  $d ]
	set eng12 [expr $eng12 - $loss12 ]

    #Setup a FTP Application over TCP connection
    set ftp12 [new Application/FTP]
    $ftp12 attach-agent $tcp11
    $ns at 13.0 "$ftp12 start"
    $ns at 14.0 "$ftp12 stop"
    set loss13 [ tr_energyloss $k  $d_nodes_intermediate_cross ]
	set eng13 [expr $eng13 - $loss13 ]

    #Setup a FTP Application over TCP connection
    set ftp13 [new Application/FTP]
    $ftp13 attach-agent $tcp10
    $ns at 14.0 "$ftp13 start"
    $ns at 15.0 "$ftp13 stop"
	set d [ expr $d_nodes_plus*2 ]
    set loss14 [ tr_energyloss $k  $d ]
	set eng14 [expr $eng14 - $loss14 ]

    #Setup a FTP Application over TCP connection
    set ftp14 [new Application/FTP]
    $ftp14 attach-agent $tcp9
    $ns at 15.0 "$ftp14 start"
    $ns at 16.0 "$ftp14 stop"
    set loss15 [ tr_energyloss $k  $d_nodes_intermediate_cross ]
	set eng15 [expr $eng15 - $loss15 ]

    #Setup a FTP Application over TCP connection
    set ftp15 [new Application/FTP]
    $ftp15 attach-agent $tcp31
    $ns at 16.0 "$ftp15 start"
    $ns at 17.0 "$ftp15 stop"
    set loss61 [ tr_energyloss $k  $d_base_station ]
	set loss62 [ rcv_energyloss $k ]
	set eng6 [expr $eng6 - $loss61 - $loss62 ]

    set count [expr $count + 1 ]
        
    puts stdout $count
	puts stdout "\n\n"
}


puts stdout "network life: $count"


#===================================
#        Termination        
#===================================
#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam out.nam &
    exit 0
}
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "\$n$i reset"
}
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run



