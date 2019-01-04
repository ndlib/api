require 'spec_helper'

# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "Agg_YearLoanPickup", :primary_key => "YearLoanPickupSK", :force => true do |t|
    t.integer "DM_ItemID"
    t.integer "YearSK",      :limit => 2
    t.integer "PickupCount"
    t.integer "LoanCount"
  end

  add_index "Agg_YearLoanPickup", ["DM_ItemID"], :name => "Agg_YearLoanPickup_Item_i"
  add_index "Agg_YearLoanPickup", ["YearSK"], :name => "Agg_YearLoanPickup_Year_i"

  create_table "Dim_AcquisitionMethod", :primary_key => "AcquisitionMethodSK", :force => true do |t|
    t.string "AcquisitionMethodCode", :limit => 2
    t.string "AcquisitionMethod",     :limit => 50
  end

  add_index "Dim_AcquisitionMethod", ["AcquisitionMethodCode"], :name => "Dim_AcquisitionMethod_i"

  create_table "Dim_ArrivalStatus", :primary_key => "ArrivalStatusSK", :force => true do |t|
    t.string "ArrivalStatusCode", :limit => 3
    t.string "ArrivalStatus",     :limit => 30
  end

  add_index "Dim_ArrivalStatus", ["ArrivalStatusCode"], :name => "Dim_ArrivalStatus_i"

  create_table "Dim_BorrowerDepartment", :primary_key => "BorrowerDepartmentSK", :force => true do |t|
    t.string "BorrowerDepartment", :limit => 50
  end

  create_table "Dim_BorrowerInstitution", :primary_key => "BorrowerInstitutionSK", :force => true do |t|
    t.string "BorrowerInstitutionCode", :limit => 2
    t.string "BorrowerInstitution",     :limit => 40
  end

  add_index "Dim_BorrowerInstitution", ["BorrowerInstitution"], :name => "Dim_BorrowerInstitution_i"

  create_table "Dim_BorrowerStatus", :primary_key => "BorrowerStatusSK", :force => true do |t|
    t.string "BorrowerStatusCode", :limit => 2
    t.string "BorrowerStatus",     :limit => 40
  end

  add_index "Dim_BorrowerStatus", ["BorrowerStatus"], :name => "Dim_BorrowerStatus_i"

  create_table "Dim_BorrowerType", :primary_key => "BorrowerTypeSK", :force => true do |t|
    t.string "BorrowerTypeCode", :limit => 2
    t.string "BorrowerType",     :limit => 40
  end

  add_index "Dim_BorrowerType", ["BorrowerType"], :name => "Dim_BorrowerType_i"

  create_table "Dim_BudgetCode", :primary_key => "BudgetCodeSK", :force => true do |t|
    t.string "BudgetCode", :limit => 45
  end

  add_index "Dim_BudgetCode", ["BudgetCode"], :name => "Dim_BudgetCode_i"

  create_table "Dim_CallNumberStart", :primary_key => "CallNumberStartSK", :force => true do |t|
    t.string "CallNumberStart", :limit => 5
  end

  add_index "Dim_CallNumberStart", ["CallNumberStart"], :name => "Dim_CallNumberStart_i"

  create_table "Dim_Collection", :primary_key => "CollectionSK", :force => true do |t|
    t.string  "CollectionCode", :limit => 5
    t.integer "SublibrarySK",   :limit => 2
    t.string  "SublibraryName", :limit => 5
  end

  add_index "Dim_Collection", ["CollectionCode"], :name => "Dim_Collection_i"
  add_index "Dim_Collection", ["SublibraryName"], :name => "Dim_Collection_SublibraryName_i"

  create_table "Dim_Date", :primary_key => "DateSK", :force => true do |t|
    t.date "FullDate"
  end

  create_table "Dim_Doc", :primary_key => "DocSK", :force => true do |t|
    t.string  "Aleph_DocNumber",     :limit => 100
    t.integer "ItemDocSK"
    t.integer "Aleph_ItemDocNumber"
    t.string  "Title",               :limit => 300
    t.string  "Imprint",             :limit => 100
    t.integer "PubYear"
    t.string  "CallNumber",          :limit => 100
    t.string  "AuthorName",          :limit => 100
    t.integer "DocFormatSK",         :limit => 2
    t.string  "ISBNOrISSN",          :limit => 100
    t.string  "TitleSorted",         :limit => 100
    t.integer "LOCClassSK",          :limit => 2
    t.integer "CallNumberStartSK",   :limit => 2
    t.string  "PhysicalText",        :limit => 100
    t.string  "GeneralText",         :limit => 100
  end

  add_index "Dim_Doc", ["Aleph_DocNumber"], :name => "Dim_Doc_Aleph_DocNumber_i"
  add_index "Dim_Doc", ["Aleph_DocNumber"], :name => "Dim_Doc_i"
  add_index "Dim_Doc", ["Aleph_ItemDocNumber"], :name => "Dim_ItemDoc_i"
  add_index "Dim_Doc", ["CallNumberStartSK"], :name => "Dim_Doc_CallNumberStart_i"
  add_index "Dim_Doc", ["DocFormatSK"], :name => "Dim_Doc_FormatSK_i"
  add_index "Dim_Doc", ["ItemDocSK"], :name => "Dim_Doc_ItemDocSK_i"
  add_index "Dim_Doc", ["Title"], :name => "Dim_Doc_Title_i"
  add_index "Dim_Doc", ["TitleSorted"], :name => "Dim_Doc_TitleSorted_i"

  create_table "Dim_DocFormat", :primary_key => "DocFormatSK", :force => true do |t|
    t.string "DocFormatCode", :limit => 10
    t.string "DocFormat",     :limit => 50
  end

  add_index "Dim_DocFormat", ["DocFormatCode"], :name => "Dim_DocFormat_i"

  create_table "Dim_FiscalBudget", :primary_key => "FiscalBudgetSK", :force => true do |t|
    t.integer "BudgetCodeSK",              :limit => 2
    t.integer "FiscalYear"
    t.date    "EffectiveDate"
    t.string  "Aleph_BudgetNumber",        :limit => 20
    t.string  "BudgetStatus",              :limit => 50
    t.string  "BannerBudgetType",          :limit => 50
    t.string  "BudgetType",                :limit => 50
    t.string  "College",                   :limit => 50
    t.string  "FundSource",                :limit => 50
    t.string  "Format",                    :limit => 50
    t.string  "Subject",                   :limit => 50
    t.string  "ExternalBudgetCode",        :limit => 50
    t.decimal "OverCommittedMaxAllowed",                 :precision => 15, :scale => 2
    t.decimal "OverExpenditureMaxAllowed",               :precision => 15, :scale => 2
    t.string  "NewBudgetCode2009",         :limit => 45
  end

  add_index "Dim_FiscalBudget", ["BudgetCodeSK", "EffectiveDate"], :name => "Dim_FiscalBudget_bced_i"
  add_index "Dim_FiscalBudget", ["BudgetCodeSK", "FiscalYear"], :name => "Dim_FiscalBudget_BC_FY_i"
  add_index "Dim_FiscalBudget", ["BudgetCodeSK"], :name => "Dim_FiscalBudget_bc_i"
  add_index "Dim_FiscalBudget", ["BudgetStatus"], :name => "Dim_FiscalBudget_BudgetStatus_i"
  add_index "Dim_FiscalBudget", ["BudgetType"], :name => "Dim_FiscalBudget_BudgetType_i"
  add_index "Dim_FiscalBudget", ["EffectiveDate"], :name => "Dim_FiscalBudget_ed_i"
  add_index "Dim_FiscalBudget", ["FiscalYear"], :name => "Dim_FiscalBudget_fy_i"
  add_index "Dim_FiscalBudget", ["Format"], :name => "Dim_FiscalBudget_Format_i"

  create_table "Dim_FiscalBudgetSelector", :primary_key => "FiscalBudgetSelectorSK", :force => true do |t|
    t.integer "FiscalBudgetSK",         :limit => 2
    t.integer "SelectorSK",             :limit => 2
    t.string  "Aleph_SelectorUserName", :limit => 10, :null => false
    t.string  "FullName",               :limit => 50
  end

  add_index "Dim_FiscalBudgetSelector", ["FiscalBudgetSK"], :name => "Dim_FiscalBudgetSelector_FiscalBudgetSK_i"
  add_index "Dim_FiscalBudgetSelector", ["SelectorSK"], :name => "Dim_FiscalBudgetSelector_SelectorSK_i"

  create_table "Dim_FiscalYear", :primary_key => "FiscalYearSK", :force => true do |t|
    t.integer "FiscalYear"
    t.date    "FiscalYearEffectiveDate"
    t.date    "FiscalYearExpirationDate"
  end

  add_index "Dim_FiscalYear", ["FiscalYear"], :name => "Dim_FiscalYear_i"

  create_table "Dim_Floor", :primary_key => "FloorSK", :force => true do |t|
    t.string "Floor", :limit => 20
  end

  add_index "Dim_Floor", ["Floor"], :name => "Dim_Floor_i"

  create_table "Dim_Holding", :primary_key => "HoldingSK", :force => true do |t|
    t.integer "DocSK"
    t.string  "Aleph_HoldingDocNumber", :limit => 100
    t.integer "LOCClassSK",             :limit => 2
    t.integer "SublibrarySK",           :limit => 2
    t.integer "CollectionSK",           :limit => 2
    t.integer "FloorSK",                :limit => 2
    t.string  "CallNumber",             :limit => 100
    t.integer "CallNumberStartSK",      :limit => 2
  end

  add_index "Dim_Holding", ["Aleph_HoldingDocNumber"], :name => "Dim_Holding_i"
  add_index "Dim_Holding", ["CallNumberStartSK"], :name => "Dim_Holding_CallNumberStart_i"
  add_index "Dim_Holding", ["CollectionSK"], :name => "Dim_Holding_Collection_i"
  add_index "Dim_Holding", ["DocSK"], :name => "Dim_Holding_Doc_i"
  add_index "Dim_Holding", ["FloorSK"], :name => "Dim_Holding_Floor_i"
  add_index "Dim_Holding", ["LOCClassSK"], :name => "Dim_Holding_LOCClass_i"
  add_index "Dim_Holding", ["SublibrarySK"], :name => "Dim_Holding_Sublibrary_i"

  create_table "Dim_Hour", :primary_key => "HourSK", :force => true do |t|
    t.integer "Hour",        :limit => 2,  :null => false
    t.string  "HourDisplay", :limit => 10
  end

  add_index "Dim_Hour", ["Hour"], :name => "Dim_Hour_i"

  create_table "Dim_InvoicePaymentStatus", :primary_key => "InvoicePaymentStatusSK", :force => true do |t|
    t.string "InvoicePaymentStatusCode", :limit => 3
    t.string "InvoicePaymentStatus",     :limit => 30
  end

  add_index "Dim_InvoicePaymentStatus", ["InvoicePaymentStatusCode"], :name => "Dim_InvoicePaymentStatus_i"

  create_table "Dim_InvoiceStatus", :primary_key => "InvoiceStatusSK", :force => true do |t|
    t.string "InvoiceStatusCode", :limit => 3
    t.string "InvoiceStatus",     :limit => 100
  end

  add_index "Dim_InvoiceStatus", ["InvoiceStatusCode"], :name => "Dim_InvoiceStatus_i"

  create_table "Dim_InvoiceType", :primary_key => "InvoiceTypeSK", :force => true do |t|
    t.string "InvoiceTypeCode", :limit => 3
    t.string "InvoiceType",     :limit => 100
  end

  add_index "Dim_InvoiceType", ["InvoiceTypeCode"], :name => "Dim_InvoiceType_i"

  create_table "Dim_Item", :primary_key => "DM_ItemID", :force => true do |t|
    t.integer  "DocSK"
    t.integer  "HoldingSK"
    t.integer  "SublibrarySK",           :limit => 2
    t.integer  "CollectionSK",           :limit => 2
    t.integer  "FloorSK",                :limit => 2
    t.integer  "DM_OrderID"
    t.string   "CallNumber",             :limit => 100
    t.integer  "CallNumberStartSK",      :limit => 2
    t.string   "Description",            :limit => 200
    t.string   "Barcode",                :limit => 30
    t.integer  "ItemStatusSK",           :limit => 2
    t.integer  "ItemProcessingStatusSK", :limit => 2
    t.integer  "MaterialTypeSK",         :limit => 2
    t.integer  "ItemAddYearSK",          :limit => 2
    t.date     "ItemAddDate"
    t.datetime "CalcLastLoanDate"
    t.integer  "CalcLoanCount"
    t.datetime "CalcLastPickupDate"
    t.integer  "CalcPickupCount"
    t.integer  "ItemRank"
  end

  add_index "Dim_Item", ["CallNumberStartSK"], :name => "Dim_Item_CallNumberStart_i"
  add_index "Dim_Item", ["CollectionSK"], :name => "Dim_Item_Collection_i"
  add_index "Dim_Item", ["DM_ItemID"], :name => "Dim_Item_i"
  add_index "Dim_Item", ["Description"], :name => "Dim_Item_Description_i"
  add_index "Dim_Item", ["DocSK"], :name => "Dim_Item_Doc_i"
  add_index "Dim_Item", ["FloorSK"], :name => "Dim_Item_Floor_i"
  add_index "Dim_Item", ["HoldingSK"], :name => "Dim_Item_Holding_i"
  add_index "Dim_Item", ["ItemAddYearSK"], :name => "Dim_Item_AddYear_i"
  add_index "Dim_Item", ["ItemProcessingStatusSK"], :name => "Dim_Item_ItemProcessingStatus_i"
  add_index "Dim_Item", ["ItemRank"], :name => "Dim_Item_ItemRank_i"
  add_index "Dim_Item", ["ItemStatusSK"], :name => "Dim_Item_ItemStatus_i"
  add_index "Dim_Item", ["MaterialTypeSK"], :name => "Dim_Item_MaterialType_i"
  add_index "Dim_Item", ["SublibrarySK"], :name => "Dim_Item_Sublibrary_i"

  create_table "Dim_ItemProcessingStatus", :primary_key => "ItemProcessingStatusSK", :force => true do |t|
    t.string "ItemProcessingStatusCode", :limit => 2
    t.string "ItemProcessingStatus",     :limit => 100
  end

  add_index "Dim_ItemProcessingStatus", ["ItemProcessingStatusCode"], :name => "Dim_ItemProcessingStatus_i"

  create_table "Dim_ItemStatus", :primary_key => "ItemStatusSK", :force => true do |t|
    t.string "ItemStatusCode", :limit => 2
    t.string "ItemStatus",     :limit => 100
  end

  add_index "Dim_ItemStatus", ["ItemStatusCode"], :name => "Dim_ItemStatus_i"

  create_table "Dim_LOCClass", :primary_key => "LOCClassSK", :force => true do |t|
    t.integer "LOCCategory",        :limit => 2
    t.string  "LOCClassDisplay",    :limit => 100
    t.string  "LOCCategoryDisplay", :limit => 100
  end

  add_index "Dim_LOCClass", ["LOCCategory"], :name => "Dim_LOCClass_i"

  create_table "Dim_MaterialType", :primary_key => "MaterialTypeSK", :force => true do |t|
    t.string "MaterialTypeCode", :limit => 5
    t.string "MaterialType",     :limit => 100
  end

  add_index "Dim_MaterialType", ["MaterialTypeCode"], :name => "Dim_MaterialType_i"

  create_table "Dim_MonthYear", :primary_key => "MonthYearSK", :force => true do |t|
    t.integer "Month"
    t.integer "Year"
    t.integer "FiscalYear"
    t.string  "MonthYearDisplay", :limit => 20
    t.integer "YearMonthConcat"
  end

  add_index "Dim_MonthYear", ["FiscalYear"], :name => "Dim_MonthYear_FiscalYear_i"
  add_index "Dim_MonthYear", ["Month"], :name => "Dim_MonthYear_Month_i"
  add_index "Dim_MonthYear", ["Year"], :name => "Dim_MonthYear_Year_i"
  add_index "Dim_MonthYear", ["YearMonthConcat"], :name => "Dim_MonthYear_YearMonthConcat_i"

  create_table "Dim_OrderGroup", :primary_key => "OrderGroupSK", :force => true do |t|
    t.string "OrderGroupCode", :limit => 10
    t.string "OrderGroup",     :limit => 50
  end

  add_index "Dim_OrderGroup", ["OrderGroupCode"], :name => "Dim_OrderGroup_i"

  create_table "Dim_OrderMaterialType", :primary_key => "OrderMaterialTypeSK", :force => true do |t|
    t.string "OrderMaterialTypeCode", :limit => 2
    t.string "OrderMaterialType",     :limit => 50
  end

  add_index "Dim_OrderMaterialType", ["OrderMaterialTypeCode"], :name => "Dim_OrderMaterialType_i"

  create_table "Dim_OrderStatus", :primary_key => "OrderStatusSK", :force => true do |t|
    t.string "OrderStatusCode", :limit => 3
    t.string "OrderStatus",     :limit => 30
  end

  add_index "Dim_OrderStatus", ["OrderStatusCode"], :name => "Dim_OrderStatus_i"

  create_table "Dim_OrderType", :primary_key => "OrderTypeSK", :force => true do |t|
    t.string "OrderTypeCode", :limit => 1
    t.string "OrderType",     :limit => 50
  end

  add_index "Dim_OrderType", ["OrderTypeCode"], :name => "Dim_OrderType_i"

  create_table "Dim_Selector", :primary_key => "SelectorSK", :force => true do |t|
    t.string "Aleph_SelectorUserName", :limit => 10, :null => false
    t.string "FullName",               :limit => 50
  end

  add_index "Dim_Selector", ["Aleph_SelectorUserName"], :name => "Dim_Selector_i"

  create_table "Dim_Sublibrary", :primary_key => "SublibrarySK", :force => true do |t|
    t.string "SublibraryName", :limit => 5
  end

  add_index "Dim_Sublibrary", ["SublibraryName"], :name => "Dim_SublibraryName_i"

  create_table "Dim_TransactionType", :primary_key => "TransactionTypeSK", :force => true do |t|
    t.string "TransactionTypeCode", :limit => 10, :null => false
  end

  add_index "Dim_TransactionType", ["TransactionTypeCode"], :name => "Dim_TransactionType_i"

  create_table "Dim_Vendor", :primary_key => "VendorSK", :force => true do |t|
    t.string "VendorCode", :limit => 20
    t.string "Vendor",     :limit => 300
  end

  add_index "Dim_Vendor", ["Vendor"], :name => "Dim_VendorName_i"
  add_index "Dim_Vendor", ["VendorCode"], :name => "Dim_Vendor_i"

  create_table "Dim_Year", :primary_key => "YearSK", :force => true do |t|
    t.integer "Year"
  end

  add_index "Dim_Year", ["Year"], :name => "Dim_Year_i"

  create_table "Fact_AssociatedOrder", :primary_key => "AssociatedOrderSK", :force => true do |t|
    t.integer "DM_OrderID",                                     :null => false
    t.integer "DM_AssociatedBudgetTransactionID",               :null => false
    t.string  "Aleph_OrderNumber",                :limit => 30
    t.integer "OrderTypeSK",                      :limit => 2
    t.integer "OrderMaterialTypeSK",              :limit => 2
    t.integer "OrderGroupSK",                     :limit => 2
    t.integer "AcquisitionMethodSK",              :limit => 2
    t.integer "ArrivalStatusSK",                  :limit => 2
    t.date    "ArrivalDate"
    t.integer "OrderStatusSK",                    :limit => 2
    t.date    "OrderStatusDate"
    t.date    "OpenDate"
    t.date    "OrderDate"
    t.date    "RenewalDate"
    t.integer "DocSK"
    t.integer "VendorSK",                         :limit => 2
  end

  create_table "Fact_BudgetAllocationTransaction", :primary_key => "DM_BudgetAllocationTransactionID", :force => true do |t|
    t.integer "FiscalBudgetSK",      :limit => 2
    t.string  "TransactionType",     :limit => 30
    t.date    "TransactionOpenDate"
    t.decimal "TransactionAmount",                 :precision => 15, :scale => 2
  end

  create_table "Fact_BudgetTransferTransaction", :primary_key => "DM_BudgetTransferTransactionID", :force => true do |t|
    t.integer "FromFiscalBudgetSK",            :limit => 2
    t.integer "ToFiscalBudgetSK",              :limit => 2
    t.integer "BudgetAllocationTransactionID", :limit => 2
    t.decimal "TransferAmount",                               :precision => 15, :scale => 2
    t.date    "TransferDate"
    t.string  "Text",                          :limit => 200
  end

  create_table "Fact_ExpBudgetTransaction", :primary_key => "DM_ExpBudgetTransactionID", :force => true do |t|
    t.integer "TransactionTypeSK",             :limit => 2
    t.integer "FiscalBudgetSK",                :limit => 2
    t.integer "BudgetCodeSK",                  :limit => 2
    t.integer "FiscalYear"
    t.string  "Aleph_BudgetNumber",            :limit => 20
    t.date    "TransactionOpenDate"
    t.string  "UserName",                      :limit => 10
    t.string  "Text",                          :limit => 200
    t.string  "TransactionAmountFormatted",    :limit => 20
    t.integer "DM_InvoiceBudgetTransactionID",                                               :null => false
    t.integer "DM_InvoiceLineItemID"
    t.string  "Aleph_InvoiceNumber",           :limit => 15
    t.integer "InvoiceTypeSK",                 :limit => 2
    t.integer "InvoiceStatusSK",               :limit => 2
    t.integer "InvoicePaymentStatusSK",        :limit => 2
    t.decimal "InvoiceTotalAmount",                           :precision => 15, :scale => 2
    t.date    "InvoiceDate"
    t.integer "LineNumber"
    t.string  "InvoiceLineItemText",           :limit => 200
    t.integer "DM_OrderID"
    t.string  "Aleph_OrderNumber",             :limit => 30
    t.integer "OrderTypeSK",                   :limit => 2
    t.integer "OrderMaterialTypeSK",           :limit => 2
    t.integer "OrderGroupSK",                  :limit => 2
    t.integer "AcquisitionMethodSK",           :limit => 2
    t.integer "ArrivalStatusSK",               :limit => 2
    t.date    "ArrivalDate"
    t.integer "OrderStatusSK",                 :limit => 2
    t.date    "OrderStatusDate"
    t.date    "OpenDate"
    t.date    "OrderDate"
    t.date    "RenewalDate"
    t.integer "DocSK"
    t.integer "VendorSK",                      :limit => 2
    t.string  "VendorNote",                    :limit => 200
    t.string  "VendorReferenceNumber",         :limit => 200
    t.string  "ItemProcessingStatuses",        :limit => 300
  end

  add_index "Fact_ExpBudgetTransaction", ["AcquisitionMethodSK"], :name => "Fact_ExpBudgetTransaction_AcquisitionMethodSK_i"
  add_index "Fact_ExpBudgetTransaction", ["Aleph_OrderNumber"], :name => "Fact_ExpBudgetTransaction_Aleph_OrderNumber_i"
  add_index "Fact_ExpBudgetTransaction", ["BudgetCodeSK", "FiscalYear"], :name => "Fact_ExpBudgetTransaction_BC_FY_i"
  add_index "Fact_ExpBudgetTransaction", ["BudgetCodeSK"], :name => "Fact_ExpBudgetTransaction_BudgetCodeSK_i"
  add_index "Fact_ExpBudgetTransaction", ["DM_InvoiceBudgetTransactionID"], :name => "Fact_ExpBudgetTransaction_IBT_ID_i"
  add_index "Fact_ExpBudgetTransaction", ["DM_OrderID"], :name => "Fact_ExpBudgetTransaction_DM_OrderID_i"
  add_index "Fact_ExpBudgetTransaction", ["DocSK"], :name => "Fact_ExpBudgetTransaction_DocSK_i"
  add_index "Fact_ExpBudgetTransaction", ["FiscalBudgetSK"], :name => "Fact_ExpBudgetTransaction_FiscalBudgetSK_i"
  add_index "Fact_ExpBudgetTransaction", ["FiscalYear"], :name => "Fact_ExpBudgetTransaction_FiscalYear_i"
  add_index "Fact_ExpBudgetTransaction", ["InvoicePaymentStatusSK"], :name => "Fact_ExpBudgetTransaction_InvoicePaymentStatusSK_i"
  add_index "Fact_ExpBudgetTransaction", ["InvoiceStatusSK"], :name => "Fact_ExpBudgetTransaction_InvoiceStatusSK_i"
  add_index "Fact_ExpBudgetTransaction", ["InvoiceTypeSK"], :name => "Fact_ExpBudgetTransaction_InvoiceTypeSK_i"
  add_index "Fact_ExpBudgetTransaction", ["OrderDate"], :name => "Fact_ExpBudgetTransaction_OrderDate_i"
  add_index "Fact_ExpBudgetTransaction", ["OrderGroupSK"], :name => "Fact_ExpBudgetTransaction_OrderGroupSK_i"
  add_index "Fact_ExpBudgetTransaction", ["OrderMaterialTypeSK"], :name => "Fact_ExpBudgetTransaction_OrderMaterialTypeSK_i"
  add_index "Fact_ExpBudgetTransaction", ["OrderStatusDate"], :name => "Fact_ExpBudgetTransaction_OrderStatusDate_i"
  add_index "Fact_ExpBudgetTransaction", ["OrderStatusSK"], :name => "Fact_ExpBudgetTransaction_OrderStatusSK_i"
  add_index "Fact_ExpBudgetTransaction", ["OrderTypeSK"], :name => "Fact_ExpBudgetTransaction_OrderTypeSK_i"
  add_index "Fact_ExpBudgetTransaction", ["TransactionTypeSK"], :name => "Fact_ExpBudgetTransaction_TransactionType_i"
  add_index "Fact_ExpBudgetTransaction", ["VendorSK"], :name => "Fact_ExpBudgetTransaction_VendorSK_i"

  create_table "Fact_Loan", :primary_key => "DM_LoanID", :force => true do |t|
    t.integer  "DM_ItemID"
    t.datetime "LoanDateTime"
    t.datetime "ReturnDateTime"
    t.string   "LoanCatalogerName",     :limit => 10
    t.string   "LoanCatalogerIP",       :limit => 45
    t.string   "LoanCatalogerDisplay",  :limit => 45
    t.integer  "LoanMonthYearSK",       :limit => 2
    t.integer  "LoanYearSK",            :limit => 2
    t.integer  "LoanHourSK",            :limit => 2
    t.integer  "ReturnYearSK",          :limit => 2
    t.integer  "ReturnHourSK",          :limit => 2
    t.integer  "ReturnMonthYearSK",     :limit => 2
    t.integer  "BorrowerTypeSK",        :limit => 2
    t.integer  "BorrowerStatusSK",      :limit => 2
    t.integer  "BorrowerInstitutionSK", :limit => 2
    t.string   "BorrowerDepartment",    :limit => 40
  end

  add_index "Fact_Loan", ["BorrowerDepartment"], :name => "Fact_Loan_BorrowerDepartment_i"
  add_index "Fact_Loan", ["BorrowerInstitutionSK"], :name => "Fact_Loan_BorrowerInstitution_i"
  add_index "Fact_Loan", ["BorrowerStatusSK"], :name => "Fact_Loan_BorrowerStatus_i"
  add_index "Fact_Loan", ["BorrowerTypeSK"], :name => "Fact_Loan_BorrowerType_i"
  add_index "Fact_Loan", ["DM_ItemID"], :name => "Fact_Loan_ItemID_i"
  add_index "Fact_Loan", ["LoanCatalogerDisplay"], :name => "Fact_Loan_CatalogerDisplay_i"
  add_index "Fact_Loan", ["LoanHourSK"], :name => "Fact_Loan_LoanHour_i"
  add_index "Fact_Loan", ["LoanMonthYearSK"], :name => "Fact_Loan_LoanMonthYear_i"
  add_index "Fact_Loan", ["LoanYearSK"], :name => "Fact_Loan_LoanYear_i"
  add_index "Fact_Loan", ["ReturnHourSK"], :name => "Fact_Loan_ReturnHour_i"
  add_index "Fact_Loan", ["ReturnMonthYearSK"], :name => "Fact_Loan_ReturnMonthYear_i"
  add_index "Fact_Loan", ["ReturnYearSK"], :name => "Fact_Loan_ReturnYear_i"

  create_table "Fact_Pickup", :primary_key => "DM_PickupID", :force => true do |t|
    t.integer  "DM_ItemID"
    t.datetime "DateTime"
    t.integer  "MonthYearSK", :limit => 2
    t.integer  "YearSK",      :limit => 2
    t.integer  "HourSK",      :limit => 2
  end

  add_index "Fact_Pickup", ["DM_ItemID"], :name => "Fact_Pickup_ItemID_i"
  add_index "Fact_Pickup", ["HourSK"], :name => "Fact_Pickup_Hour_i"
  add_index "Fact_Pickup", ["MonthYearSK"], :name => "Fact_Pickup_MonthYear_i"
  add_index "Fact_Pickup", ["YearSK"], :name => "Fact_Pickup_Year_i"

  create_table "Lc_location_codes", :id => false, :force => true do |t|
    t.string  "Lc_code_a",   :limit => 3
    t.integer "Lc_code_n"
    t.integer "tc_category"
  end

  create_table "acq_mthd", :primary_key => "acq_mthd_cde", :force => true do |t|
    t.string "dsc", :limit => 30, :null => false
  end

  create_table "annl_bdgt", :id => false, :force => true do |t|
    t.string  "bdgt_cde",                 :limit => 15,                                :null => false
    t.date    "annl_bdgt_eff_dt",                                                      :null => false
    t.date    "vld_frm_dt",                                                            :null => false
    t.date    "vld_to_dt",                                                             :null => false
    t.date    "opn_dt",                                                                :null => false
    t.string  "status_cde",               :limit => 2,                                 :null => false
    t.string  "bnnr_bdgt_typ_cde",        :limit => 5
    t.string  "bdgt_typ_cde",             :limit => 5
    t.string  "collg_cde",                :limit => 5
    t.string  "fnd_src_cde",              :limit => 5
    t.string  "frmt_cde",                 :limit => 5
    t.string  "subj_cde",                 :limit => 20
    t.string  "ext_bdgt_cde",             :limit => 50
    t.string  "aleph_bdgt_nbr",           :limit => 20
    t.string  "annl_crryovr_ind",         :limit => 1,                                 :null => false
    t.decimal "ovr_cmtted_max_allw_nbr",                :precision => 15, :scale => 2, :null => false
    t.decimal "ovr_expndtr_max_allw_nbr",               :precision => 15, :scale => 2, :null => false
    t.string  "amt_pct_cde",              :limit => 1,                                 :null => false
    t.string  "crdt_dbt_cde",             :limit => 1,                                 :null => false
  end

  add_index "annl_bdgt", ["annl_bdgt_eff_dt"], :name => "annl_bdgt_eff_dt_fk_i"
  add_index "annl_bdgt", ["bdgt_cde"], :name => "annl_bdgt_bdgt_fk_i"
  add_index "annl_bdgt", ["bdgt_typ_cde"], :name => "annl_bdgt_bdgt_typ_fk_i"
  add_index "annl_bdgt", ["bnnr_bdgt_typ_cde"], :name => "annl_bdgt_bnnr_bdgt_typ_fk_i"
  add_index "annl_bdgt", ["collg_cde"], :name => "annl_bdgt_collg_fk_i"
  add_index "annl_bdgt", ["ext_bdgt_cde"], :name => "annl_bdgt_ext_bdgt_cde_i"
  add_index "annl_bdgt", ["fnd_src_cde"], :name => "annl_bdgt_fnd_src_fk_i"
  add_index "annl_bdgt", ["frmt_cde"], :name => "annl_bdgt_frmt_fk_i"
  add_index "annl_bdgt", ["subj_cde"], :name => "annl_bdgt_subj_fk_i"

  create_table "annl_bdgt_slctr", :id => false, :force => true do |t|
    t.string "bdgt_cde",         :limit => 15, :default => "", :null => false
    t.date   "annl_bdgt_eff_dt",                               :null => false
    t.string "slctr_usr_nm",     :limit => 10, :default => "", :null => false
  end

  add_index "annl_bdgt_slctr", ["annl_bdgt_eff_dt"], :name => "annl_bdgt_slctr_eff_dt_fk_i"
  add_index "annl_bdgt_slctr", ["bdgt_cde", "annl_bdgt_eff_dt"], :name => "annl_bdgt_slctr_annl_bdgt_fk_i"
  add_index "annl_bdgt_slctr", ["slctr_usr_nm"], :name => "annl_bdgt_slctr_slctr_fk_i"

  create_table "apprvl_pln_bdgt", :id => false, :force => true do |t|
    t.string "bdgt_cde", :limit => 20
    t.string "bdgt_dsc", :limit => 50
  end

  create_table "arrvl_status", :primary_key => "arrvl_status_cde", :force => true do |t|
    t.string "dsc", :limit => 30, :null => false
  end

  create_table "bdgt", :primary_key => "bdgt_cde", :force => true do |t|
    t.string "dsc",          :limit => 100, :null => false
    t.string "new_bdgt_cde", :limit => 15
  end

  create_table "bdgt_tran", :primary_key => "bdgt_tran_id", :force => true do |t|
    t.string  "bdgt_cde",          :limit => 15
    t.date    "annl_bdgt_eff_dt"
    t.date    "tran_opn_dt"
    t.string  "bdgt_tran_typ_cde", :limit => 3,                                  :null => false
    t.integer "ordr_id"
    t.integer "invc_ln_itm_id"
    t.string  "usr_nm",            :limit => 10
    t.string  "txt",               :limit => 200
    t.string  "crdt_dbt_cde",      :limit => 1,                                  :null => false
    t.decimal "tran_org_amt",                     :precision => 15, :scale => 2, :null => false
    t.decimal "tran_actv_amt",                    :precision => 15, :scale => 2, :null => false
    t.decimal "tran_lcl_amt",                     :precision => 15, :scale => 2, :null => false
  end

  add_index "bdgt_tran", ["bdgt_cde", "annl_bdgt_eff_dt"], :name => "bdgt_tran_annl_bdgt_fk_i"
  add_index "bdgt_tran", ["bdgt_tran_typ_cde"], :name => "bdgt_tran_bdgt_tran_typ_fk_i"
  add_index "bdgt_tran", ["invc_ln_itm_id"], :name => "bdgt_tran_invc_ln_itm_fk_i"

  create_table "bdgt_tran_typ", :primary_key => "bdgt_tran_typ_cde", :force => true do |t|
    t.string "bdgt_tran_typ_grp_cde", :limit => 3
    t.string "dsc",                   :limit => 30, :null => false
  end

  add_index "bdgt_tran_typ", ["bdgt_tran_typ_grp_cde"], :name => "bdgt_tran_typ_grp_fk_i"

  create_table "bdgt_tran_typ_grp", :primary_key => "bdgt_tran_typ_grp_cde", :force => true do |t|
    t.string "dsc", :limit => 30, :null => false
  end

  create_table "bdgt_trsfr", :primary_key => "bdgt_trsfr_id", :force => true do |t|
    t.string  "frm_bdgt_cde",         :limit => 15,                                 :null => false
    t.date    "frm_annl_bdgt_eff_dt",                                               :null => false
    t.string  "to_bdgt_cde",          :limit => 15,                                 :null => false
    t.date    "to_annl_bdgt_eff_dt",                                                :null => false
    t.integer "bdgt_tran_id",                                                       :null => false
    t.date    "trsfr_dt",                                                           :null => false
    t.decimal "trsfr_amt",                           :precision => 15, :scale => 2, :null => false
    t.string  "txt",                  :limit => 200
  end

  add_index "bdgt_trsfr", ["frm_bdgt_cde", "frm_annl_bdgt_eff_dt"], :name => "bdgt_trsfr_frm_fk_i"
  add_index "bdgt_trsfr", ["to_bdgt_cde", "to_annl_bdgt_eff_dt"], :name => "bdgt_trsfr_to_fk_i"

  create_table "bdgt_typ", :primary_key => "bdgt_typ_cde", :force => true do |t|
    t.string "dsc", :limit => 50, :null => false
  end

  create_table "bnnr_bdgt_typ", :primary_key => "bnnr_bdgt_typ_cde", :force => true do |t|
    t.string "dsc", :limit => 50, :null => false
  end

  create_table "bor_inst", :primary_key => "bor_inst_cde", :force => true do |t|
    t.string "dsc", :limit => 40
  end

  create_table "bor_status", :primary_key => "bor_status_cde", :force => true do |t|
    t.string "dsc", :limit => 40
  end

  create_table "bor_typ", :primary_key => "bor_typ_cde", :force => true do |t|
    t.string "dsc", :limit => 40
  end

  create_table "call_nbr_rng", :id => false, :force => true do |t|
    t.integer "call_nbr_rng_id"
    t.string  "call_nbr_ltr",    :limit => 30
    t.string  "call_nbr_strt",   :limit => 30
    t.string  "call_nbr_end",    :limit => 30
    t.string  "call_nbr_nm",     :limit => 100
    t.string  "call_nbr_slctr",  :limit => 50
  end

  create_table "cancel_doc_info_v", :id => false, :force => true do |t|
    t.string  "doc_nbr",    :limit => 9,                     :null => false
    t.string  "ttl_txt",    :limit => 100, :default => "NA", :null => false
    t.string  "imprnt_txt", :limit => 100
    t.string  "lbry_nm",    :limit => 0
    t.string  "call_nbr",   :limit => 100
    t.integer "er_ind",                    :default => 0,    :null => false
  end

  create_table "cancel_doc_v", :id => false, :force => true do |t|
    t.string "doc_nbr", :limit => 9,                     :null => false
    t.string "ttl_txt", :limit => 100, :default => "NA", :null => false
  end

  create_table "cancel_item_info_v", :id => false, :force => true do |t|
    t.string  "doc_nbr",    :limit => 9,                     :null => false
    t.string  "ttl_txt",    :limit => 100, :default => "NA", :null => false
    t.string  "imprnt_txt", :limit => 100
    t.string  "lbry_nm",    :limit => 0
    t.string  "call_nbr",   :limit => 100
    t.integer "er_ind",                    :default => 0,    :null => false
  end

  create_table "circ_hist", :primary_key => "circ_hist_id", :force => true do |t|
    t.string   "adm_doc_nbr",    :limit => 9
    t.string   "itm_seq_nbr",    :limit => 6
    t.string   "bor_inst_cde",   :limit => 2
    t.string   "bor_status_cde", :limit => 2
    t.string   "bor_dept_nm",    :limit => 100
    t.datetime "rtrn_dt_tm"
    t.string   "loan_lbry_nm",   :limit => 5
  end

  add_index "circ_hist", ["adm_doc_nbr"], :name => "circ_hist_adm_doc_nbr_i"
  add_index "circ_hist", ["bor_dept_nm"], :name => "circ_hist_bor_dept_nm_i"
  add_index "circ_hist", ["bor_inst_cde"], :name => "circ_hist_bor_inst_cde_i"
  add_index "circ_hist", ["bor_status_cde"], :name => "circ_hist_bor_status_cde_i"
  add_index "circ_hist", ["loan_lbry_nm"], :name => "circ_hist_loan_lbry_nm_i"
  add_index "circ_hist", ["rtrn_dt_tm"], :name => "circ_hist_rtrn_dt_tm_i"

  create_table "coll", :id => false, :force => true do |t|
    t.string "coll_cde", :limit => 5
  end

  create_table "collg", :primary_key => "collg_cde", :force => true do |t|
    t.string "dsc", :limit => 50
  end

  create_table "del_itm", :id => false, :force => true do |t|
    t.integer "del_itm_id",                         :null => false
    t.string  "doc_nbr",             :limit => 9
    t.string  "adm_doc_nbr",         :limit => 9
    t.string  "hldng_doc_nbr",       :limit => 9
    t.string  "itm_seq_nbr",         :limit => 6
    t.string  "brcde",               :limit => 30
    t.string  "lbry_nm",             :limit => 3
    t.string  "sublbry_nm",          :limit => 5
    t.string  "itm_status_cde",      :limit => 2
    t.string  "itm_proc_status_cde", :limit => 2
    t.string  "mtrl_typ_cde",        :limit => 5
    t.date    "opn_dt"
    t.date    "del_dt"
    t.string  "del_ctlgr_nm",        :limit => 10
    t.string  "coll_cde",            :limit => 5
    t.string  "call_nbr",            :limit => 80
    t.string  "dsc",                 :limit => 200
    t.string  "note_opac",           :limit => 200
    t.string  "note_circ",           :limit => 200
    t.string  "note_intrnl",         :limit => 200
  end

  add_index "del_itm", ["adm_doc_nbr"], :name => "del_itm_adm_doc_nbr_i"
  add_index "del_itm", ["brcde"], :name => "del_itm_brcde_i"
  add_index "del_itm", ["coll_cde"], :name => "del_itm_coll_cde_i"
  add_index "del_itm", ["del_itm_id"], :name => "del_itm_i"
  add_index "del_itm", ["doc_nbr"], :name => "del_itm_doc_nbr_i"
  add_index "del_itm", ["hldng_doc_nbr"], :name => "del_itm_hldng_doc_nbr_i"
  add_index "del_itm", ["sublbry_nm"], :name => "del_itm_sublbry_nm_i"

  create_table "doc", :primary_key => "doc_nbr", :force => true do |t|
    t.string  "itm_doc_nbr",   :limit => 9
    t.integer "series_id"
    t.integer "pub_yr"
    t.date    "opn_dt"
    t.date    "updt_dt"
    t.string  "call_nbr",      :limit => 100
    t.string  "lbry_call_nbr", :limit => 100
    t.string  "authr_nm",      :limit => 100
    t.string  "ttl_txt",       :limit => 100, :default => "NA", :null => false
    t.string  "ttl_sort_txt",  :limit => 100, :default => "NA", :null => false
    t.string  "imprnt_txt",    :limit => 100
    t.string  "isbn_issn_txt", :limit => 100
    t.string  "lng_cde",       :limit => 3
    t.string  "edtn_txt",      :limit => 50
    t.string  "frmt_cde",      :limit => 10
    t.string  "supr_ind",      :limit => 1
    t.string  "del_ind",       :limit => 1
    t.string  "phys_txt",      :limit => 100
    t.string  "gen_txt",       :limit => 100
  end

  add_index "doc", ["doc_nbr"], :name => "doc_nbr_ft"
  add_index "doc", ["frmt_cde"], :name => "doc_frmt_fk_i"
  add_index "doc", ["itm_doc_nbr"], :name => "doc_itm_doc_nbr"
  add_index "doc", ["lbry_call_nbr"], :name => "lbry_call_nbr_i"
  add_index "doc", ["lng_cde"], :name => "doc_lng_fk_i"
  add_index "doc", ["pub_yr"], :name => "doc_pub_yr_i"
  add_index "doc", ["series_id"], :name => "doc_series_fk_i"
  add_index "doc", ["ttl_txt"], :name => "doc_ttl_ft"

  create_table "doc_035", :id => false, :force => true do |t|
    t.string  "doc_nbr",    :limit => 9,  :default => "", :null => false
    t.string  "fld_txt",    :limit => 20, :default => "", :null => false
    t.string  "subfld_cde", :limit => 1
    t.string  "fld_cde",    :limit => 4
    t.integer "seq_nbr"
  end

  add_index "doc_035", ["doc_nbr"], :name => "doc_035_doc_fk_i"

  create_table "doc_for_cancel", :primary_key => "doc_nbr", :force => true do |t|
    t.string "ttl_txt",      :limit => 100, :default => "NA", :null => false
    t.string "ttl_sort_txt", :limit => 100, :default => "NA", :null => false
  end

  add_index "doc_for_cancel", ["doc_nbr"], :name => "doc_fc_nbr_ft"
  add_index "doc_for_cancel", ["ttl_sort_txt"], :name => "doc_fc_ttl_sort_txt_i"
  add_index "doc_for_cancel", ["ttl_txt"], :name => "doc_fc_ttl_ft"

  create_table "doc_frmt", :id => false, :force => true do |t|
    t.string "frmt_cde", :limit => 2
    t.string "dsc",      :limit => 50
  end

  create_table "doc_isbn_issn", :id => false, :force => true do |t|
    t.string  "doc_nbr",             :limit => 9,  :null => false
    t.string  "isbn_issn_txt",       :limit => 20, :null => false
    t.string  "clean_isbn_issn_txt", :limit => 20, :null => false
    t.string  "subfld_cde",          :limit => 1
    t.string  "fld_cde",             :limit => 4
    t.integer "seq_nbr"
  end

  add_index "doc_isbn_issn", ["doc_nbr"], :name => "doc_isbn_issn_doc_fk_i"

  create_table "flr", :id => false, :force => true do |t|
    t.string  "flr_nm",      :limit => 20
    t.integer "flr_seq_nbr"
  end

  create_table "fnd_src", :primary_key => "fnd_src_cde", :force => true do |t|
    t.string "dsc", :limit => 50
  end

  create_table "frmt", :primary_key => "frmt_cde", :force => true do |t|
    t.string "dsc", :limit => 50
  end

  create_table "fscl_yr", :id => false, :force => true do |t|
    t.integer "yr_nbr"
    t.date    "yr_bgn_dt"
    t.date    "yr_end_dt"
  end

  create_table "func", :primary_key => "func_cde", :force => true do |t|
    t.string "dsc", :limit => 50
  end

  create_table "hldng", :primary_key => "hldng_doc_nbr", :force => true do |t|
    t.string  "doc_nbr",     :limit => 9
    t.string  "call_nbr",    :limit => 100
    t.integer "lc_ctgy_cde"
    t.string  "sublbry_nm",  :limit => 5
    t.string  "coll_cde",    :limit => 20
    t.string  "flr_nm",      :limit => 20
  end

  add_index "hldng", ["call_nbr"], :name => "hldng_call_nbr_i"
  add_index "hldng", ["coll_cde"], :name => "hldng_coll_cde_i"
  add_index "hldng", ["doc_nbr"], :name => "hldng_doc_nbr_fk_i"
  add_index "hldng", ["hldng_doc_nbr"], :name => "hldng_hldng_doc_nbr_i"
  add_index "hldng", ["lc_ctgy_cde"], :name => "hldng_lc_ctgy_cde_i"
  add_index "hldng", ["sublbry_nm"], :name => "hldng_sublbry_i"

  create_table "ill_tran", :primary_key => "tran_nbr", :force => true do |t|
    t.string   "req_typ_nm",     :limit => 8
    t.string   "doc_typ_nm",     :limit => 50
    t.string   "proc_typ_nm",    :limit => 20
    t.string   "tran_status_nm", :limit => 40
    t.datetime "tran_dt_tm"
    t.datetime "sub_dt_tm"
    t.string   "issn_txt",       :limit => 30
    t.string   "ill_nbr",        :limit => 32
    t.string   "esp_nbr",        :limit => 32
    t.string   "lnd_str_txt",    :limit => 150
    t.string   "lnd_lbry_nm",    :limit => 30
    t.string   "cncl_rsn_txt",   :limit => 100
    t.string   "call_nbr",       :limit => 100
    t.string   "web_req_frm",    :limit => 50
    t.string   "bor_status_nm",  :limit => 20
    t.string   "bor_dept_nm"
    t.string   "bor_lbry_nm",    :limit => 50
    t.string   "bor_f_nm",       :limit => 100
    t.string   "bor_l_nm",       :limit => 100
  end

  create_table "ill_tran_article", :primary_key => "tran_nbr", :force => true do |t|
    t.string "jrnl_ttl_txt",       :limit => 455
    t.string "jrnl_vol_nbr"
    t.string "jrnl_iss_nbr"
    t.string "jrnl_mnth_txt"
    t.string "jrnl_yr_txt"
    t.string "jrnl_incl_pgs_txt"
    t.string "jrn_artcl_authr_nm"
    t.string "cite_txt"
    t.string "jrnl_artcl_ttl_txt", :limit => 455
  end

  create_table "ill_tran_loan", :primary_key => "tran_nbr", :force => true do |t|
    t.string "authr_nm", :limit => 455
    t.string "ttl_txt",  :limit => 455
    t.string "pub_nm",   :limit => 455
    t.string "pub_plc",  :limit => 400
    t.string "pub_yr",   :limit => 100
  end

  create_table "invc", :id => false, :force => true do |t|
    t.string  "vndr_cde",             :limit => 20,                                :null => false
    t.string  "invc_nbr",             :limit => 15,                                :null => false
    t.string  "invc_typ_cde",         :limit => 3
    t.string  "invc_status_cde",      :limit => 3
    t.string  "invc_pymt_status_cde", :limit => 1
    t.string  "crdt_dbt_cde",         :limit => 1,                                 :null => false
    t.decimal "net_amt",                            :precision => 15, :scale => 2
    t.decimal "shpmnt_amt",                         :precision => 15, :scale => 2
    t.decimal "ovr_amt",                            :precision => 15, :scale => 2
    t.decimal "insrnc_amt",                         :precision => 15, :scale => 2
    t.decimal "discnt_amt",                         :precision => 15, :scale => 2
    t.decimal "ttl_amt",                            :precision => 15, :scale => 2
    t.date    "invc_dt"
    t.date    "rcvd_dt"
    t.date    "shpmt_dt"
  end

  add_index "invc", ["invc_pymt_status_cde"], :name => "invc_invc_pymt_status_fk_i"
  add_index "invc", ["invc_status_cde"], :name => "invc_invc_status_fk_i"
  add_index "invc", ["invc_typ_cde"], :name => "invc_invc_typ_fk_i"
  add_index "invc", ["vndr_cde"], :name => "invc_vndr_fk_i"

  create_table "invc_ln_itm", :primary_key => "invc_ln_itm_id", :force => true do |t|
    t.string  "vndr_cde",     :limit => 20,                                 :null => false
    t.string  "invc_nbr",     :limit => 15,                                 :null => false
    t.integer "ln_nbr"
    t.integer "ordr_id"
    t.string  "doc_nbr",      :limit => 9
    t.string  "adm_doc_nbr",  :limit => 9
    t.string  "crdt_dbt_cde", :limit => 1
    t.decimal "list_prc_amt",                :precision => 15, :scale => 2
    t.string  "txt",          :limit => 200
  end

  add_index "invc_ln_itm", ["doc_nbr"], :name => "invc_ln_itm_doc_fk_i"
  add_index "invc_ln_itm", ["invc_nbr", "vndr_cde"], :name => "invc_ln_itm_invc_fk_i"
  add_index "invc_ln_itm", ["ordr_id"], :name => "invc_ln_itm_ordr_fk_i"

  create_table "invc_pymt_status", :primary_key => "invc_pymt_status_cde", :force => true do |t|
    t.string "dsc", :limit => 30
  end

  create_table "invc_status", :primary_key => "invc_status_cde", :force => true do |t|
    t.string "dsc", :limit => 100, :null => false
  end

  create_table "invc_typ", :primary_key => "invc_typ_cde", :force => true do |t|
    t.string "dsc", :limit => 100, :null => false
  end

  create_table "itm", :primary_key => "itm_id", :force => true do |t|
    t.string  "doc_nbr",              :limit => 9
    t.string  "adm_doc_nbr",          :limit => 9
    t.string  "hldng_doc_nbr",        :limit => 9
    t.string  "itm_seq_nbr",          :limit => 6
    t.string  "brcde",                :limit => 30
    t.string  "lbry_nm",              :limit => 3
    t.string  "sublbry_nm",           :limit => 5
    t.integer "ordr_id"
    t.string  "itm_status_cde",       :limit => 2
    t.string  "itm_proc_status_cde",  :limit => 2
    t.string  "mtrl_typ_cde",         :limit => 5
    t.date    "opn_dt"
    t.date    "lst_upd_dt"
    t.date    "lst_rtrn_dt_tm"
    t.integer "loan_cnt"
    t.string  "ctlgr_nm",             :limit => 10
    t.string  "coll_cde",             :limit => 5
    t.string  "flr_nm",               :limit => 20
    t.string  "call_nbr",             :limit => 80
    t.string  "dsc",                  :limit => 200
    t.string  "note_opac",            :limit => 200
    t.string  "note_circ",            :limit => 200
    t.string  "note_intrnl",          :limit => 200
    t.string  "subs_nbr",             :limit => 10
    t.date    "issue_dt"
    t.date    "issue_expct_arrvl_dt"
    t.date    "issue_arrvl_dt"
    t.decimal "issue_aggr_prc",                      :precision => 18, :scale => 2
  end

  add_index "itm", ["adm_doc_nbr"], :name => "itm_adm_doc_nbr_i"
  add_index "itm", ["brcde"], :name => "itm_brcde_i"
  add_index "itm", ["call_nbr"], :name => "itm_call_nbr_i"
  add_index "itm", ["coll_cde"], :name => "itm_coll_cde_i"
  add_index "itm", ["doc_nbr"], :name => "itm_doc_nbr_i"
  add_index "itm", ["flr_nm"], :name => "itm_flr_nm_i"
  add_index "itm", ["hldng_doc_nbr"], :name => "itm_hldng_doc_nbr_i"
  add_index "itm", ["itm_proc_status_cde"], :name => "itm_itm_proc_status_fk_i"
  add_index "itm", ["itm_status_cde"], :name => "itm_itm_status_fk_i"
  add_index "itm", ["loan_cnt"], :name => "itm_loan_cnt_i"
  add_index "itm", ["lst_rtrn_dt_tm"], :name => "itm_lst_rtrn_dt_tm_i"
  add_index "itm", ["mtrl_typ_cde"], :name => "itm_mtrl_typ_fk_i"
  add_index "itm", ["opn_dt"], :name => "itm_opn_dt_i"
  add_index "itm", ["ordr_id"], :name => "itm_ordr_id_i"
  add_index "itm", ["sublbry_nm"], :name => "itm_sublbry_nm_i"

  create_table "itm_proc_status", :primary_key => "itm_proc_status_cde", :force => true do |t|
    t.string "dsc", :limit => 40
  end

  create_table "itm_status", :primary_key => "itm_status_cde", :force => true do |t|
    t.string "dsc", :limit => 40
  end

  create_table "lc_ctgy", :id => false, :force => true do |t|
    t.string "lc_ctgy_cde",  :limit => 3
    t.string "call_nbr_dsc", :limit => 100
    t.string "dsc",          :limit => 100
  end

  create_table "lc_location_categories", :id => false, :force => true do |t|
    t.integer "tc_category"
    t.string  "tc_text",     :limit => 30
    t.string  "lc_text",     :limit => 80
  end

  create_table "loan", :primary_key => "loan_id", :force => true do |t|
    t.integer  "itm_id"
    t.string   "aleph_loan_nbr",     :limit => 9
    t.string   "loan_status_cde",    :limit => 1
    t.datetime "loan_dt_tm"
    t.datetime "loan_due_dt_tm"
    t.date     "org_loan_due_dt"
    t.string   "loan_ctlgr_nm",      :limit => 10
    t.string   "loan_ctlgr_ip_addr", :limit => 50
    t.string   "loan_lbry_nm",       :limit => 3
    t.string   "loan_sublbry_nm",    :limit => 5
    t.date     "rcll_snt_dt"
    t.date     "rcll_due_dt"
    t.string   "rcll_typ_cde",       :limit => 2
    t.date     "lst_ovrdue_ntc_dt"
    t.integer  "ovrdue_ntc_cnt"
    t.date     "lst_rnwl_dt"
    t.integer  "rnwl_cnt"
    t.string   "rnwl_mode_cde",      :limit => 10
    t.string   "rnwl_ctlgr_nm",      :limit => 10
    t.datetime "rtrn_dt_tm"
    t.string   "rtrn_ctlgr_nm",      :limit => 10
    t.string   "bor_status_cde",     :limit => 2
    t.string   "bor_typ_cde",        :limit => 2
    t.string   "bor_inst_cde",       :limit => 2
    t.string   "bor_dept_nm",        :limit => 100
    t.string   "note_1",             :limit => 30
    t.string   "note_2",             :limit => 30
  end

  add_index "loan", ["bor_inst_cde"], :name => "loan_bor_inst_fk_i"
  add_index "loan", ["bor_status_cde"], :name => "loan_bor_status_fk_i"
  add_index "loan", ["bor_typ_cde"], :name => "loan_bor_typ_fk_i"
  add_index "loan", ["itm_id"], :name => "loan_itm_fk_i"
  add_index "loan", ["loan_ctlgr_ip_addr"], :name => "loan_ctlgr_ip_addr_i"
  add_index "loan", ["loan_ctlgr_nm"], :name => "loan_ctlgr_nm_i"
  add_index "loan", ["loan_dt_tm"], :name => "loan_loan_dt_tm_i"
  add_index "loan", ["loan_status_cde"], :name => "loan_loan_status_fk_i"
  add_index "loan", ["rcll_typ_cde"], :name => "loan_rcll_typ_fk_i"
  add_index "loan", ["rtrn_dt_tm"], :name => "loan_rtrn_dt_tm_i"

  create_table "loan_status", :primary_key => "loan_status_cde", :force => true do |t|
    t.string "dsc", :limit => 40
  end

  create_table "mtrl_typ", :primary_key => "mtrl_typ_cde", :force => true do |t|
    t.string "dsc", :limit => 50
  end

  create_table "ordr", :primary_key => "ordr_id", :force => true do |t|
    t.string  "ordr_typ_cde",       :limit => 1,                                  :null => false
    t.string  "ordr_mtrl_typ_cde",  :limit => 2
    t.string  "ordr_grp_cde",       :limit => 10
    t.string  "acq_mthd_cde",       :limit => 2
    t.string  "arrvl_status_cde",   :limit => 1
    t.string  "ordr_mtrl_frmt_cde", :limit => 10
    t.string  "ordr_status_cde",    :limit => 3,                                  :null => false
    t.date    "ordr_status_dt"
    t.string  "ordr_nbr",           :limit => 30,                                 :null => false
    t.string  "ordr_nbr_1",         :limit => 30
    t.string  "doc_nbr",            :limit => 9
    t.string  "adm_doc_nbr",        :limit => 9
    t.string  "prnt_onln_doc_nbr",  :limit => 9
    t.date    "open_dt",                                                          :null => false
    t.string  "vndr_cde",           :limit => 20,                                 :null => false
    t.date    "ordr_dt",                                                          :null => false
    t.string  "ordrd_by_usr_nm",    :limit => 10
    t.decimal "ordr_lcl_amt",                      :precision => 15, :scale => 2
    t.string  "sublbry_nm",         :limit => 5
    t.date    "subs_rnwl_dt"
    t.string  "rush_ind",           :limit => 1
    t.string  "lbry_note",          :limit => 200
    t.string  "qty_note",           :limit => 500
    t.string  "prc_note",           :limit => 500
    t.string  "vndr_note",          :limit => 200
    t.string  "vndr_ref_no",        :limit => 200
    t.string  "rtrn_tran_typ_cde",  :limit => 2
  end

  add_index "ordr", ["acq_mthd_cde"], :name => "ordr_acq_mthd_fk_i"
  add_index "ordr", ["adm_doc_nbr"], :name => "ordr_adm_doc_nbr_i"
  add_index "ordr", ["arrvl_status_cde"], :name => "ordr_arrvl_status_fk_i"
  add_index "ordr", ["doc_nbr"], :name => "ordr_doc_fk_i"
  add_index "ordr", ["ordr_grp_cde"], :name => "ordr_ordr_grp_fk_i"
  add_index "ordr", ["ordr_mtrl_frmt_cde"], :name => "ordr_ordr_mtrl_frmt_fk_i"
  add_index "ordr", ["ordr_mtrl_typ_cde"], :name => "ordr_ordr_mtrl_typ_fk_i"
  add_index "ordr", ["ordr_nbr"], :name => "ordr_ordr_nbr_i"
  add_index "ordr", ["ordr_status_cde"], :name => "ordr_ordr_status_fk_i"
  add_index "ordr", ["ordr_typ_cde"], :name => "ordr_ordr_typ_fk_i"
  add_index "ordr", ["prnt_onln_doc_nbr"], :name => "ordr_prnt_onln_doc_nbr_i"
  add_index "ordr", ["vndr_cde"], :name => "ordr_vndr_fk_i"

  create_table "ordr_arrival", :id => false, :force => true do |t|
    t.integer "ordr_id",                       :default => 0,  :null => false
    t.string  "arrival_seq_nbr", :limit => 6,  :default => "", :null => false
    t.date    "arrival_dt"
    t.integer "units_arr_nbr"
    t.date    "ship_dt"
    t.string  "arrival_note",    :limit => 60
  end

  create_table "ordr_claim", :id => false, :force => true do |t|
    t.integer "ordr_id",                       :default => 0,  :null => false
    t.string  "claim_seq_nbr",  :limit => 6,   :default => "", :null => false
    t.date    "claim_dt"
    t.date    "print_dt"
    t.string  "claim_txt",      :limit => 200
    t.string  "vndr_reply_txt", :limit => 200
    t.date    "vndr_reply_dt"
  end

  create_table "ordr_grp", :primary_key => "ordr_grp_cde", :force => true do |t|
    t.string "dsc", :limit => 50, :null => false
  end

  create_table "ordr_lg_tran_typ", :primary_key => "ordr_lg_tran_typ_cde", :force => true do |t|
    t.string "dsc", :limit => 300
  end

  create_table "ordr_mtrl_frmt", :primary_key => "ordr_mtrl_frmt_cde", :force => true do |t|
    t.string "dsc", :limit => 30
  end

  create_table "ordr_mtrl_typ", :primary_key => "ordr_mtrl_typ_cde", :force => true do |t|
    t.string "dsc", :limit => 30, :null => false
  end

  create_table "ordr_status", :primary_key => "ordr_status_cde", :force => true do |t|
    t.string "ordr_status_grp_cde", :limit => 10
    t.string "dsc",                 :limit => 30, :null => false
  end

  add_index "ordr_status", ["ordr_status_grp_cde"], :name => "ordr_status_grp_fk_i"

  create_table "ordr_status_grp", :primary_key => "ordr_status_grp_cde", :force => true do |t|
    t.string "dsc", :limit => 50
  end

  create_table "ordr_typ", :primary_key => "ordr_typ_cde", :force => true do |t|
    t.string "dsc", :limit => 50, :null => false
  end

  create_table "pckp", :primary_key => "pckp_id", :force => true do |t|
    t.integer  "itm_id"
    t.datetime "pckp_dt_tm"
    t.string   "pckp_ctlgr_nm",      :limit => 10
    t.string   "pckp_ctlgr_ip_addr", :limit => 50
  end

  add_index "pckp", ["itm_id"], :name => "pckp_itm_id_i"
  add_index "pckp", ["pckp_dt_tm"], :name => "pckp_pckp_dt_tm_i"

  create_table "plat", :primary_key => "plat_id", :force => true do |t|
    t.string  "nm",            :limit => 150
    t.string  "rprt_dsply_nm", :limit => 150
    t.integer "rprt_dflt_ind"
  end

  add_index "plat", ["nm"], :name => "plat_nm_i"
  add_index "plat", ["rprt_dflt_ind"], :name => "plat_rprt_dflt_ind_i"
  add_index "plat", ["rprt_dsply_nm"], :name => "plat_rprt_dsply_nm_i"

  create_table "plat_intrfc", :primary_key => "plat_intrfc_id", :force => true do |t|
    t.integer "plat_id"
    t.integer "strt_yr"
    t.integer "end_yr"
    t.integer "cntr_cmplnt_ind"
    t.integer "HTML_multi_ind"
    t.string  "intrfc_note",     :limit => 2000
  end

  create_table "pub", :primary_key => "pub_id", :force => true do |t|
    t.string "nm", :limit => 150
  end

  add_index "pub", ["nm"], :name => "pub_nm_i"

  create_table "pub_note", :primary_key => "pub_note_id", :force => true do |t|
    t.integer "pub_plat_id"
    t.integer "strt_yr"
    t.integer "end_yr"
    t.string  "note",        :limit => 2000
  end

  create_table "pub_plat", :primary_key => "pub_plat_id", :force => true do |t|
    t.integer "pub_id"
    t.integer "plat_id"
    t.string  "rprt_dsply_nm", :limit => 150
    t.integer "rprt_dflt_ind"
  end

  add_index "pub_plat", ["plat_id"], :name => "pub_plat_plat_id_i"
  add_index "pub_plat", ["pub_id"], :name => "pub_plat_pub_id_i"
  add_index "pub_plat", ["rprt_dflt_ind"], :name => "pub_plat_rprt_dflt_ind_i"
  add_index "pub_plat", ["rprt_dsply_nm"], :name => "pub_plat_rprt_dsply_nm_i"

  create_table "quarter", :id => false, :force => true do |t|
    t.string "quarter_bgn_mth_day", :limit => 4
    t.string "quarter_end_mth_day", :limit => 4
    t.string "quarter_dsply",       :limit => 20
  end

  create_table "rcll_typ", :primary_key => "rcll_typ_cde", :force => true do |t|
    t.string "dsc", :limit => 40
  end

  create_table "recent_dates", :id => false, :force => true do |t|
    t.integer "nbr_days",                   :null => false
    t.string  "display_days", :limit => 20, :null => false
  end

  create_table "rnwl", :primary_key => "rnwl_id", :force => true do |t|
    t.integer  "itm_id"
    t.datetime "rnwl_dt_tm"
    t.string   "rnwl_mode_cde",      :limit => 10
    t.string   "rnwl_ctlgr_nm",      :limit => 10
    t.string   "rnwl_ctlgr_ip_addr", :limit => 50
  end

  add_index "rnwl", ["itm_id"], :name => "rnwl_itm_fk_i"
  add_index "rnwl", ["rnwl_dt_tm"], :name => "rnwl_rnwl_dt_tm_i"

  create_table "semester", :id => false, :force => true do |t|
    t.string "semester_bgn_mth_day", :limit => 4
    t.string "semester_end_mth_day", :limit => 4
    t.string "semester_dsply",       :limit => 30
  end

  create_table "series", :primary_key => "series_id", :force => true do |t|
    t.string "dsc", :limit => 500
  end

  create_table "slctr", :primary_key => "slctr_usr_nm", :force => true do |t|
    t.string "full_nm", :limit => 50,  :null => false
    t.string "dpt_nm",  :limit => 100
  end

  create_table "subfunc", :id => false, :force => true do |t|
    t.string "func_cde",    :limit => 20, :null => false
    t.string "subfunc_cde", :limit => 20, :null => false
    t.string "dsc",         :limit => 50
  end

  create_table "subj", :primary_key => "subj_cde", :force => true do |t|
    t.string "dsc", :limit => 50
  end

  create_table "subl_coll", :id => false, :force => true do |t|
    t.string "sublbry_nm", :limit => 5
    t.string "coll_cde",   :limit => 5
  end

  create_table "sublbry", :id => false, :force => true do |t|
    t.string "sublbry_nm", :limit => 5
  end

  create_table "sys_usr", :primary_key => "sys_usr_nm", :force => true do |t|
  end

  create_table "ttl", :primary_key => "ttl_id", :force => true do |t|
    t.string "ttl_txt",      :limit => 200
    t.string "ttl_sort_txt", :limit => 200
    t.string "sfx_id",       :limit => 20
  end

  add_index "ttl", ["sfx_id"], :name => "ttl_sfx_id_i"

  create_table "ttl_issn", :primary_key => "ttl_issn_id", :force => true do |t|
    t.integer "ttl_id"
    t.string  "issn_txt",         :limit => 20
    t.string  "issn_typ_cde",     :limit => 20
    t.string  "issn_chg_rsn_txt", :limit => 20
  end

  add_index "ttl_issn", ["issn_txt"], :name => "ttl_issn_issn_txt_i"
  add_index "ttl_issn", ["issn_typ_cde"], :name => "ttl_issn_issn_typ_i"
  add_index "ttl_issn", ["ttl_id"], :name => "ttl_issn_ttl_fk_i"

  create_table "ttl_stat_mthly", :primary_key => "ttl_stat_mthly_id", :force => true do |t|
    t.integer "ttl_id"
    t.integer "pub_plat_id"
    t.integer "yr"
    t.integer "mth"
    t.integer "archv_ind"
    t.integer "usage_cnt"
    t.integer "ovrrd_usage_cnt"
    t.integer "outlier_id"
    t.integer "ignr_outlier_ind"
    t.integer "merge_ind"
  end

  add_index "ttl_stat_mthly", ["archv_ind"], :name => "ttl_stat_mthly_archv_ind_i"
  add_index "ttl_stat_mthly", ["merge_ind"], :name => "ttl_stat_mthly_merge_ind_i"
  add_index "ttl_stat_mthly", ["mth"], :name => "ttl_stat_mthly_mth_i"
  add_index "ttl_stat_mthly", ["outlier_id"], :name => "ttl_stat_mthly_outlier_id_i"
  add_index "ttl_stat_mthly", ["pub_plat_id"], :name => "ttl_stat_mthly_pub_plat_fk_i"
  add_index "ttl_stat_mthly", ["ttl_id"], :name => "ttl_stat_mthly_ttl_fk_i"
  add_index "ttl_stat_mthly", ["yr"], :name => "ttl_stat_mthly_yr_i"

  create_table "ttl_stat_ytd", :primary_key => "ttl_stat_ytd_id", :force => true do |t|
    t.integer "ttl_id"
    t.integer "pub_plat_id"
    t.integer "yr"
    t.integer "archv_ind"
    t.integer "tot_cnt"
    t.integer "html_cnt"
    t.integer "pdf_cnt"
    t.integer "ovrrd_tot_cnt"
    t.integer "ovrrd_html_cnt"
    t.integer "ovrrd_pdf_cnt"
    t.integer "merge_ind"
  end

  add_index "ttl_stat_ytd", ["archv_ind"], :name => "ttl_stat_ytd_archv_ind_i"
  add_index "ttl_stat_ytd", ["merge_ind"], :name => "ttl_stat_ytd_merge_ind_i"
  add_index "ttl_stat_ytd", ["pub_plat_id"], :name => "ttl_stat_ytd_pub_plat_fk_i"
  add_index "ttl_stat_ytd", ["ttl_id"], :name => "ttl_stat_ytd_ttl_fk_i"
  add_index "ttl_stat_ytd", ["yr"], :name => "ttl_stat_ytd_yr_i"

  create_table "updt", :id => false, :force => true do |t|
    t.datetime "updt_strt_dt",               :null => false
    t.datetime "updt_end_dt"
    t.string   "srvr_nm",      :limit => 30
  end

  create_table "usr_lg", :id => false, :force => true do |t|
    t.string    "net_id", :limit => 25
    t.timestamp "dt_tm",                  :null => false
    t.string    "url",    :limit => 1000
  end

  create_table "usr_prmssn", :primary_key => "usr_prmssn_id", :force => true do |t|
    t.string "sys_usr_nm",     :limit => 10
    t.string "sys_lbry_nm",    :limit => 5
    t.string "sys_sublbry_nm", :limit => 5
    t.string "func_cde",       :limit => 20
    t.string "subfunc_cde",    :limit => 20
    t.string "prmssn_ind",     :limit => 1
  end

  add_index "usr_prmssn", ["func_cde"], :name => "usr_prmssn_func_fk_i"
  add_index "usr_prmssn", ["subfunc_cde"], :name => "usr_prmssn_subfunc_fk_i"

  create_table "usr_prxy", :primary_key => "usr_nm", :force => true do |t|
    t.string "prxy_typ_nm", :limit => 20
    t.string "usr_lbry_nm", :limit => 5
    t.string "sys_usr_nm",  :limit => 10
  end

  create_table "vndr", :primary_key => "vndr_cde", :force => true do |t|
    t.string "nm",         :limit => 150, :null => false
    t.string "addr_nm",    :limit => 100
    t.string "edi_site",   :limit => 100
    t.string "edi_usr_nm", :limit => 100
    t.string "edi_pwd",    :limit => 100
    t.string "edi_prtcl",  :limit => 100
    t.string "edi_pth",    :limit => 300
    t.string "cntry_nm",   :limit => 100
  end

  add_index "vndr", ["nm"], :name => "vndr_nm_i"

end
