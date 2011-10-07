class MergeTwoSandyAdams < ActiveRecord::Migration
  def up
    Politician.find_by_gov_track_id(400269).update_attribute(:vote_smart_id, 26898)
    {
      '31041' => 412414,
      '42352' => 412493,
      '47143' => 412469,
      '28963' => 412404,
      '123056' => 412436,
      '7693' => 412458,
      '25292' => 412478,
      '121610' => 412395,
      '120335' => 412427,
      '127047' => 412456,
      '1568' => 412490,
      '53291' => 402675,
      '50146' => 412481,
      '53658' => 412407,
      '7349' => 412470,
      '19913' => 412440,
      '122953' => 412441,
      '119208' => 412400,
      '122834' => 412390,
      '28769' => 412403,
      '116548' => 412420,
      '126238' => 412488,
      '47967' => 412472,
      '123473' => 412477, # Scott DesJarlais -> Scott DesJarlais
      '120897' => 412457, # Renee Ellmers -> Renee Ellmers
      '124659' => 412479, # Stephen Fincher -> Stephen Fincher
      '123456' => 412476, # Chuck Fleischmann -> Chuck Fleischmann
      '116919' => 412482, # Blake Farenthold -> R. Farenthold
      '116906' => 412480, # Bill Flores -> Bill Flores
      '30004' => 412406, # Cory Gardner -> Cory Gardner
      '45466' => 412463, # Bob Gibbs -> Bob Gibbs
      '127042' => 412453, # Chris Gibson -> Christopher Gibson
      '123491' => 412397, # Paul Gosar -> Paul Gosar
      '121782' => 412473, # Trey Gowdy -> Trey Gowdy
      '119213' => 412401, # Tim Griffin -> Tim Griffin
      '5148' => 412485, # H. Griffith -> H. Morgan Griffith
      '127075' => 412451, # Michael Grimm -> Michael Grimm
      '42946' => 412447, # Frank Guinta -> Frank Guinta
      '17745' => 412418, # Colleen Hanabusa -> Colleen Hanabusa
      '110344' => 412454, # Richard Hanna -> Richard Hanna
      '19157' => 412434, # Andy Harris -> Andrew Harris
      '8783' => 412444, # Vicky Hartzler -> Vicky Hartzler
      '127041' => 412452, # Nan Hayworth -> Nan Hayworth
      '44082' => 412446, # Joe Heck -> Joseph Heck
      '101907' => 412486, # Jaime Herrera Beutler -> Jaime Herrera
      '12571' => 412429, # Tim Huelskamp -> Tim Huelskamp
      '38351' => 412437, # Bill Huizenga -> Bill Huizenga
      '18199' => 412422, # Randy Hultgren -> Randall Hultgren
      '50895' => 412484, # Robert Hurt -> Robert Hurt
      '41788' => 412494, # John Hoeven -> John Hoeven
      '120649' => 412460, # Bill Johnson -> Bill Johnson
      '126217' => 412496, # Ron Johnson -> Ron Johnson
      '4743' => 412435, # William Keating -> William Keating
      '119463' => 412465, # Mike Kelly -> Mike Kelly
      '116559' => 412421, # Adam Kinzinger -> Adam Kinzinger
      '57391' => 412419, # Raúl Labrador -> Raúl Labrador
      '93509' => 412433, # Jeff Landry -> Jeff Landry
      '124938' => 412464, # James Lankford -> James Lankford
      '123401' => 412445, # Billy Long -> Billy Long
      '66395' => 412495, # Mike Lee -> Michael Lee
      '119478' => 412468, # Thomas Marino -> Thomas Marino
      '117396' => 412487, # David McKinley -> David McKinley
      '119474' => 412466, # Patrick Meehan -> Patrick Meehan
      '60348' => 412474, # Mick Mulvaney -> Michael Mulvaney
      '7547' => 412391, # Joe Manchin -> Joe Manchin
      '58189' => 412475, # Kristi Noem -> Kristi Noem
      '124333' => 412409, # Richard Nugent -> Richard Nugent
      '8326' => 412442, # Alan Nunnelee -> Patrick Nunnelee
      '69521' => 412443, # Steven Palazzo -> Steven Palazzo
      '125023' => 412431, # Mike Pompeo -> Mike Pompeo
      '117285' => 412492, # Rand Paul -> Rand Paul
      '123506' => 412398, # Ben Quayle -> Ben Quayle
      '127046' => 412393, # Tom Reed -> Thomas Reed
      '120678' => 412462, # Jim Renacci -> James Renacci
      '126240' => 412489, # Reid Ribble -> Reid Ribble
      '35384' => 412432, # Cedric Richmond -> Cedric Richmond
      '121807' => 412483, # E. Rigell -> E. Rigell
      '31234' => 412415, # David Rivera -> David Rivera
      '71604' => 412394, # Martha Roby -> Martha Roby
      '34167' => 412426, # Todd Rokita -> Todd Rokita
      '12813' => 412411, # Dennis Ross -> Dennis Ross
      '121117' => 412449, # Jon Runyan -> Jon Runyan
      '1601' => 412491, # Marco Rubio -> Marco Rubio
      '116570' => 412423, # Robert Schilling -> Robert Schilling
      '106387' => 412399, # David Schweikert -> David Schweikert
      '11940' => 412471, # Tim Scott -> Tim Scott
      '121621' => 412396, # Terri Sewell -> Terri Sewell
      '124329' => 412408, # Steve Southerland -> Steve Southerland
      '45333' => 412461, # Steve Stivers -> Steve Stivers
      '34230' => 412392, # Marlin Stutzman -> Marlin Stutzman
      '11812' => 412417, # Austin Scott -> James Scott
      '65403' => 412405, # Scott Tipton -> Scott Tipton
      '127071' => 412499, # Robert Turner -> Robert Turner
      '24302' => 412410, # Daniel Webster -> Daniel Webster
      '124348' => 412413, # Allen West -> Allen West
      '17319' => 412412, # Frederica Wilson -> Frederica Wilson
      '71815' => 412402, # Steve Womack -> Steve Womack
      '122251' => 412416, # Rob Woodall -> Rob Woodall
      '116545' => 412424, # Joe Walsh -> Joe Walsh
      '34433' => 412430, # Kevin Yoder -> Kevin Yoder
      '120345' => 412428, # Todd Young -> Todd Young
     }.each_pair do |vote_smart_id, gov_track_id|
      p1 = Politician.find_by_vote_smart_id(vote_smart_id)
      p2 = Politician.find_by_gov_track_id(gov_track_id)
      if p1 && p2 && p1 != p2
        puts "Merging #{p2.name} into #{p1.name}"
        if gov_track_id == 402675
          p2.report_scores.each do |report_score|
            if p1.report_scores.where(report_id: report_score.report_id).exists?
              print 'x'
            end
          end
        end
        p1.merge!(p2)
        puts
      end
    end
  end

  def down
  end
end
