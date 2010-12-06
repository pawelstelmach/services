# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101109211555) do

  create_table "concept_edges", :force => true do |t|
    t.integer  "from_id"
    t.integer  "to_id"
    t.float    "length"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "concepts", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.text     "meta_in"
    t.text     "meta_out"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "routing_table"
  end

  create_table "services", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "input"
    t.string   "output"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cost"
    t.integer  "response_time"
    t.float    "availability"
    t.float    "succesful"
    t.float    "reputation"
    t.float    "frequency"
  end

end
