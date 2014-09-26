require 'kanban'

namespace :one_time do
  task process_missing_shepherds: :environment do
    to_up = [
      { fogbugz_id: 18507, tags: 'Shepherd: Lewis Moten' },
      { fogbugz_id: 18919, tags: 'Shepherd: Bob Flanders' },
      { fogbugz_id: 19701, tags: 'Shepherd: Phil McMillan' },
      { fogbugz_id: 19474, tags: 'Shepherd: Brian Chiasson' },
      { fogbugz_id: 20503, tags: 'Shepherd: Bryant Smith' },
      { fogbugz_id: 20729, tags: 'Shepherd: Charles Jekal' },
      { fogbugz_id: 20750, tags: 'Shepherd: Bryant Smith' },
      { fogbugz_id: 19689, tags: 'Shepherd: Lewis Moten' },
      { fogbugz_id: 20775, tags: 'Shepherd: Don Dykhoff' },
      { fogbugz_id: 19257, tags: 'Shepherd: Art Machnev' },
      { fogbugz_id: 20725, tags: 'Shepherd: Brian Chiasson' },
      { fogbugz_id: 20765, tags: 'Shepherd: Brian Chiasson' },
      { fogbugz_id: 20711, tags: 'Shepherd: Art Machnev' },
      { fogbugz_id: 20783, tags: 'Shepherd: Matt Ingram' },
      { fogbugz_id: 20730, tags: 'Shepherd: Art Machnev' },
      { fogbugz_id: 20232, tags: 'Shepherd: Charles Jekal' },
      { fogbugz_id: 20683, tags: 'Shepherd: Bryant Smith' },
      { fogbugz_id: 20770, tags: 'Shepherd: Art Machnev' },
      { fogbugz_id: 20756, tags: 'Shepherd: Don Dykhoff' },
      { fogbugz_id: 20595, tags: 'Shepherd: Art Machnev' },
      { fogbugz_id: 20618, tags: 'Shepherd: Art Machnev' },
      { fogbugz_id: 19896, tags: 'Shepherd: Brian Chiasson' },
      { fogbugz_id: 20509, tags: 'Shepherd: Bryant Smith' },
      { fogbugz_id: 20501, tags: 'Shepherd: Bryant Smith' },
      { fogbugz_id: 19897, tags: 'Shepherd: Charles Jekal' },
      { fogbugz_id: 19883, tags: 'Shepherd: Brian Chiasson' }
    ]

    to_up.each do |up|
      cards = LeanKitKanban::Card.find_by_external_id(46341228, up[:fogbugz_id])[0]
      cards.each do |card|
        if card['Tags'].blank?
          puts "FB: #{up[:fogbugz_id]} ID: #{card['Id']} changing '#{card['Tags']}' to '#{up[:tags]}'"
          card['Tags'] = up[:tags]
          response = LeanKitKanban::Card.update(46341228, card)
          raise "The card FB: #{up[:fogbugz_id]} failed to update.\n#{response}" if response[0]['BoardVersion'].blank?
        end
      end
    end
  end

  task process_again: :environment do
    to_up = [
      19689,
      19701,
      19257,
      20882,
      20775,
      20725,
      20765,
      20729,
      20711,
      20783,
      20730,
      20232,
      20683,
      20706,
      20311,
      20770,
      20756,
      20750,
      20231,
      20595,
      20618,
      19474,
      17943,
      20249,
      20548,
      20557,
      20559,
      20470,
      20524,
      20474,
      19896,
      20470,
      19900,
      19355,
      20385,
      20509,
      20501,
      20503,
      20367,
      20252,
      19353,
      20029,
      19730,
      20233,
      19307,
      20306,
      20055,
      20160,
      19897,
      19919,
      18409,
      19984,
      19474,
      19747,
      19883,
      19746,
      19354,
      19309,
      19631,
      19066,
      19351,
      19353,
      18080,
      19505,
      19347,
      18738,
      18237,
      18131,
      18053,
      18131,
      18055,
      19211,
      18982,
      19281,
      19261,
      18814,
      18902,
      19064,
      18080,
      19076,
      18901,
      18919,
      18898,
      19032,
      18899,
      18705,
      18052,
      18903,
      18901,
      18507,
      18904,
      18918,
      18902,
      18175,
      18507,
      18814,
      18896,
      18905,
      18897,
      18898,
      19045,
      18132,
      19830,
      20586,
      20588,
      20587
    ]

    to_up.each do |up|
      cards = LeanKitKanban::Card.find_by_external_id(46341228, up)[0]
      cards.each do |card|
        if card['Tags'].blank? && card['AssignedUserIds'].length > 0
          tag = "Shepherd: #{find_user(card['AssignedUserIds'][0])}" if card['AssignedUserIds'].length > 0
          unless tag.nil?
            puts "FB: #{up} ID: #{card['Id']} changing '#{card['Tags']}' to '#{tag}'"
            card['Tags'] = tag
            response = LeanKitKanban::Card.update(46341228, card)
            raise "The card FB: #{up} failed to update.\n#{response}" if response[0]['BoardVersion'].blank?
          end
        end
      end
    end
  end

  task missing_estimates: :environment do
    to_up = [
      	{ fogbugz_id: 15929, size: 8 },
      	{ fogbugz_id: 17879, size: 5 },
      	{ fogbugz_id: 18052, size: 66 },
      	{ fogbugz_id: 18080, size: 24 },
      	{ fogbugz_id: 18131, size: 29 },
      	{ fogbugz_id: 18409, size: 19 },
      	{ fogbugz_id: 18507, size: 78 },
      	{ fogbugz_id: 18705, size: 103 },
      	{ fogbugz_id: 18814, size: 58 },
      	{ fogbugz_id: 18872, size: 62 },
      	{ fogbugz_id: 18898, size: 14 },
      	{ fogbugz_id: 18901, size: 12 },
      	{ fogbugz_id: 18902, size: 12 },
      	{ fogbugz_id: 18919, size: 39 },
      	{ fogbugz_id: 18982, size: 14 },
      	{ fogbugz_id: 18998, size: 2 },
      	{ fogbugz_id: 19029, size: 1 },
      	{ fogbugz_id: 19031, size: 7 },
      	{ fogbugz_id: 19040, size: 1 },
      	{ fogbugz_id: 19048, size: 2 },
      	{ fogbugz_id: 19058, size: 19 },
      	{ fogbugz_id: 19073, size: 2 },
      	{ fogbugz_id: 19074, size: 3 },
      	{ fogbugz_id: 19076, size: 12 },
      	{ fogbugz_id: 19099, size: 13 },
      	{ fogbugz_id: 19102, size: 16 },
      	{ fogbugz_id: 19115, size: 19 },
      	{ fogbugz_id: 19118, size: 39 },
      	{ fogbugz_id: 19122, size: 17 },
      	{ fogbugz_id: 19123, size: 5 },
      	{ fogbugz_id: 19127, size: 5 },
      	{ fogbugz_id: 19140, size: 11 },
      	{ fogbugz_id: 19149, size: 3 },
      	{ fogbugz_id: 19184, size: 30 },
      	{ fogbugz_id: 19225, size: 7 },
      	{ fogbugz_id: 19332, size: 2 },
      	{ fogbugz_id: 19350, size: 16 },
      	{ fogbugz_id: 19474, size: 5 },
      	{ fogbugz_id: 19627, size: 9 },
      	{ fogbugz_id: 19630, size: 21 },
      	{ fogbugz_id: 19689, size: 18 },
      	{ fogbugz_id: 19692, size: 7 },
      	{ fogbugz_id: 19697, size: 18 },
      	{ fogbugz_id: 19701, size: 3 },
      	{ fogbugz_id: 19702, size: 10 },
      	{ fogbugz_id: 19867, size: 23 },
      	{ fogbugz_id: 19884, size: 19 },
      	{ fogbugz_id: 19958, size: 9 },
      	{ fogbugz_id: 19966, size: 17 },
      	{ fogbugz_id: 19978, size: 11 },
      	{ fogbugz_id: 19995, size: 17 },
      	{ fogbugz_id: 20041, size: 20 },
      	{ fogbugz_id: 20042, size: 7 },
      	{ fogbugz_id: 20154, size: 7 },
      	{ fogbugz_id: 20160, size: 1 },
      	{ fogbugz_id: 20169, size: 7 },
      	{ fogbugz_id: 20173, size: 10 },
      	{ fogbugz_id: 20249, size: 10 },
      	{ fogbugz_id: 20252, size: 33 },
      	{ fogbugz_id: 20253, size: 10 },
      	{ fogbugz_id: 20254, size: 6 },
      	{ fogbugz_id: 20312, size: 9 },
      	{ fogbugz_id: 20314, size: 6 },
      	{ fogbugz_id: 20366, size: 28 },
      	{ fogbugz_id: 20424, size: 8 },
      	{ fogbugz_id: 20457, size: 3 },
      	{ fogbugz_id: 20460, size: 7 },
      	{ fogbugz_id: 20467, size: 4 },
      	{ fogbugz_id: 20470, size: 6 },
      	{ fogbugz_id: 20501, size: 9 },
      	{ fogbugz_id: 20503, size: 18 },
      	{ fogbugz_id: 20506, size: 6 },
      	{ fogbugz_id: 20513, size: 10 },
      	{ fogbugz_id: 20529, size: 2 },
      	{ fogbugz_id: 20543, size: 31 },
      	{ fogbugz_id: 20548, size: 3 },
      	{ fogbugz_id: 20557, size: 4 },
      	{ fogbugz_id: 20559, size: 1 },
      	{ fogbugz_id: 20577, size: 19 },
      	{ fogbugz_id: 20578, size: 7 },
      	{ fogbugz_id: 20583, size: 7 },
      	{ fogbugz_id: 20586, size: 1 },
      	{ fogbugz_id: 20587, size: 2 },
      	{ fogbugz_id: 20588, size: 2 },
      	{ fogbugz_id: 20595, size: 10 },
      	{ fogbugz_id: 20614, size: 4 },
      	{ fogbugz_id: 20617, size: 6 },
      	{ fogbugz_id: 20630, size: 8 },
      	{ fogbugz_id: 20634, size: 2 },
      	{ fogbugz_id: 20646, size: 3 },
      	{ fogbugz_id: 20658, size: 1 },
      	{ fogbugz_id: 20682, size: 1 },
      	{ fogbugz_id: 20691, size: 13 },
      	{ fogbugz_id: 20698, size: 33 },
      	{ fogbugz_id: 20699, size: 3 },
      	{ fogbugz_id: 20700, size: 2 },
      	{ fogbugz_id: 20704, size: 1 },
      	{ fogbugz_id: 20706, size: 22 },
      	{ fogbugz_id: 20707, size: 14 },
      	{ fogbugz_id: 20708, size: 3 },
      	{ fogbugz_id: 20719, size: 5 },
      	{ fogbugz_id: 20722, size: 9 },
      	{ fogbugz_id: 20725, size: 2 },
      	{ fogbugz_id: 20729, size: 11 },
      	{ fogbugz_id: 20732, size: 5 },
      	{ fogbugz_id: 20733, size: 12 },
      	{ fogbugz_id: 20737, size: 17 },
      	{ fogbugz_id: 20743, size: 12 },
      	{ fogbugz_id: 20746, size: 1 },
      	{ fogbugz_id: 20750, size: 7 },
      	{ fogbugz_id: 20756, size: 7 },
      	{ fogbugz_id: 20758, size: 4 },
      	{ fogbugz_id: 20765, size: 8 },
      	{ fogbugz_id: 20767, size: 19 },
      	{ fogbugz_id: 20769, size: 2 },
      	{ fogbugz_id: 20770, size: 2 },
      	{ fogbugz_id: 20783, size: 1 },
      	{ fogbugz_id: 20792, size: 3 },
      	{ fogbugz_id: 20793, size: 4 },
      	{ fogbugz_id: 20794, size: 3 },
      	{ fogbugz_id: 20802, size: 1 },
      	{ fogbugz_id: 20818, size: 2 },
      	{ fogbugz_id: 20822, size: 6 },
      	{ fogbugz_id: 20835, size: 5 },
      	{ fogbugz_id: 20836, size: 2 },
      	{ fogbugz_id: 20840, size: 5 },
      	{ fogbugz_id: 20852, size: 2 },
      	{ fogbugz_id: 20868, size: 1 },
      	{ fogbugz_id: 20882, size: 1 },
      	{ fogbugz_id: 20922, size: 2 },
      	{ fogbugz_id: 20942, size: 2 },
      	{ fogbugz_id: 20943, size: 2 },
      	{ fogbugz_id: 20956, size: 2 },
      	{ fogbugz_id: 20970, size: 3 },
    ]

    to_up.each do |up|
      cards = LeanKitKanban::Card.find_by_external_id(46341228, up[:fogbugz_id])[0]
      puts "TWO CARDS FOUND! FB: #{up[:fogbugz_id]}" if cards.length > 0
      cards.each do |card|
        if card['Size'].blank? || card['Size'] == 0
          lane = find_lane(card['LaneId'])
          next unless ['Done', 'Ready to Release'].include?(lane)
          puts "FB: #{up[:fogbugz_id]} ID: #{card['Id']} changing '#{card['Size']}' to '#{up[:size]}'"
          card['Size'] = up[:size]
          response = LeanKitKanban::Card.update(46341228, card)
          raise "The card FB: #{up[:fogbugz_id]} failed to update.\n#{response}" if response[0]['BoardVersion'].blank?

          kc = Kanban::Card.new(card.merge(:lane => lane))
          if TaskMetric.saveable?(kc)
            metric = TaskMetric.from(kc)
            metric.historical = true
            metric.save!
          end
        end
      end
    end
  end

  def find_lane(lane_id)
    @identifiers ||= LeanKitKanban::Board.get_identifiers(46341228)[0]
    @lanes ||= @identifiers['Lanes']

    lane = @lanes.select {|l| l['Id'] == lane_id }
    raise "Cannot find lane: #{lane_id}" if lane.length == 0
    raise "Identified too many lanes: #{lane}" if lane.length > 1

    lane[0]['Name']
  end

  def find_user(user_id)
    @identifiers ||= LeanKitKanban::Board.get_identifiers(46341228)[0]
    @users ||= @identifiers['BoardUsers']

    user = @users.select {|u| u['Id'] == user_id }
    raise "Cannot find user: #{user_id}" if user.length == 0
    raise "Identified too many users: #{user}" if user.length > 1

    email = user[0]['Name']
    case email
    when 'c.jekal@arpc.com'
      return 'Charles Jekal'
    when 'b.chiasson@arpc.com'
      return 'Brian Chiasson'
    when 'j.skinner@arpc.com'
      return 'Julian Skinner'
    when 'b.smith@arpc.com'
      return 'Bryant Smith'
    when 'r.flanders@arpc.com'
      return 'Bob Flanders'
    when 'alexei.frolov@ent0.com'
      return 'Alexei Frolov'
    when 'a.machnev@arpc.com'
      return 'Artem Machnev'
    when 'phil.mcmillan@ent0.com'
      return 'Phil McMillan'
    when 'l.moten@arpc.com'
      return 'Lewis Moten'
    else
      return nil
    end
  end
end
