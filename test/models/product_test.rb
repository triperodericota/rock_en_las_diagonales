require 'test_helper'

class ProductTest < ActiveSupport::TestCase

  setup do
    @product1 = products(:product1)
    @product2 = products(:product2)
    @product3 = Product.create(title: 'La mosca y la sopa', price: 10, stock: 0, artist: artists(:artist2))
  end

  teardown do
    @product3.destroy
  end

  test "should valid if it's has stock" do
    assert @product1.in_stock?
    assert_not @product3.in_stock?
  end

  test "should valid report stock" do
    assert_equal @product1.report_stock, '1 unidad/es disponibles'
    assert_equal @product3.report_stock, 'Por el momento no se dispone de stock'
  end

  test "should valid if stock is greater or equals than a number" do
    assert @product2.stock_greater_or_equals_than? 5
    assert @product1.stock_greater_or_equals_than? 1
  end




end
