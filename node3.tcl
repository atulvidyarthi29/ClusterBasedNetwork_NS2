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
set val(nn)     5                          ;# number of mobilenodes
set val(rp)     DSDV                       ;# routing protocol
set val(x)      433                      ;# X dimension of topography
set val(y)      100                      ;# Y dimension of topography
set val(stop)   10.0                         ;# time of simulation end

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
#Create 5 nodes

#Create 5 nodes

$ns node-config -initialEnergy 1
set n0 [$ns node]
$n0 set X_ 0
$n0 set Y_ 200
$n0 set Z_ 0.0
$ns initial_node_pos $n0 20
set eng0 [$n0 energy]


# cluster head
$ns node-config -initialEnergy 3
set n1 [$ns node]
$n1 set X_ 200
$n1 set Y_ 200
$n1 set Z_ 0.0
$ns initial_node_pos $n1 20
set eng1 [$n1 energy]

$ns node-config -initialEnergy 1
set n2 [$ns node]
$n2 set X_ 0
$n2 set Y_ 0
$n2 set Z_ 0.0
$ns initial_node_pos $n2 20
set eng2 [$n2 energy]

$ns node-config -initialEnergy 1
set n3 [$ns node]
$n3 set X_ 200
$n3 set Y_ 0
$n3 set Z_ 0.0
$ns initial_node_pos $n3 20
set eng3 [$n3 energy]


# base station
$ns node-config -initialEnergy 1
set n4 [$ns node]
$n4 set X_ 100
$n4 set Y_ 300
$n4 set Z_ 0.0
$ns initial_node_pos $n4 20
set eng4 [$n4 energy]

#===================================
#        Functions        
#===================================

proc distance {x y z} {
    
    set n1_x 200
    set n1_y 200
    set n1_z 0
    set diffx [expr $n1_x-$x]
    set diffy [expr $n1_y-$y]
    set diffz [expr $n1_z-$z]
    set pow_x [pow $diffx 2]
    set pow_y [pow $diffy 2]
    set pow_z [pow $diffz 2]
    set total [expr $pow_x + $pow_y + $pow_z]
    return [sqrt $total]
}

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
$ns attach-agent $n0 $tcp0
set sink6 [new Agent/TCPSink]
$ns attach-agent $n1 $sink6
$ns connect $tcp0 $sink6
$tcp0 set packetSize_ 1500

#Setup a TCP connection
set tcp1 [new Agent/TCP]
$ns attach-agent $n2 $tcp1
set sink4 [new Agent/TCPSink]
$ns attach-agent $n1 $sink4
$ns connect $tcp1 $sink4
$tcp1 set packetSize_ 1500

#Setup a TCP connection
set tcp2 [new Agent/TCP]
$ns attach-agent $n3 $tcp2
set sink7 [new Agent/TCPSink]
$ns attach-agent $n1 $sink7
$ns connect $tcp2 $sink7
$tcp2 set packetSize_ 1500

#Setup a TCP connection
set tcp3 [new Agent/TCP]
$ns attach-agent $n1 $tcp3
set sink5 [new Agent/TCPSink]
$ns attach-agent $n4 $sink5
$ns connect $tcp3 $sink5
$tcp3 set packetSize_ 1500


#===================================
#        Applications Definition        
#===================================

set k [expr 10*8*pow(10,6)]
set d_nodes_plus 100
set d_nodes_cross [ expr 100 * 1.41 ] 
set d_base_station 100


set count 0

while { $eng0 > 0 || $eng3 > 0 || $eng2 > 0 && $eng1 > 0 } {

	#Setup a FTP Application over TCP connection
	set ftp0 [new Application/FTP]
	$ftp0 attach-agent $tcp0
	$ns at 1.0 "$ftp0 start"
	$ns at 2.0 "$ftp0 stop"
	set loss0 [ tr_energyloss $k  $d_nodes_plus ]
	set eng0 [expr $eng0 - $loss0 ]

	#Setup a FTP Application over TCP connection
	set ftp1 [new Application/FTP]
	$ftp1 attach-agent $tcp1
	$ns at 2.0 "$ftp1 start"
	$ns at 3.0 "$ftp1 stop"
	set loss2 [ tr_energyloss $k  $d_nodes_cross ]
	set eng2 [expr $eng2 - $loss2 ]

	#Setup a FTP Application over TCP connection
	set ftp2 [new Application/FTP]
	$ftp2 attach-agent $tcp2
	$ns at 3.0 "$ftp2 start"
	$ns at 4.0 "$ftp2 stop"
	set loss3 [ tr_energyloss $k  $d_nodes_plus ]
	set eng3 [expr $eng3 - $loss3 ]

	#Setup a FTP Application over TCP connection
	set ftp3 [new Application/FTP]
	$ftp3 attach-agent $tcp3
	$ns at 4.0 "$ftp3 start"
	$ns at 5.0 "$ftp3 stop"
	set loss11 [ tr_energyloss $k  $d_base_station ]
	set loss12 [ rcv_energyloss $k ]
	set eng1 [expr $eng4 - $loss11 - $loss12 ]

	set count [expr $count + 1 ]
        
	puts stdout $eng0
	puts stdout $eng1
	puts stdout $eng2
	puts stdout $eng3
        #puts stdout $count
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
