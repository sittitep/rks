require_relative "./test_helper"

class TestLogger < Minitest::Test
  def setup
    @logger = RKS::Logger.init

    @mock_request = Minitest::Mock.new
    @mock_request.expect :params, "baz"
  end

  def test_with_rescue_and_duration_event_finished
    stdout = capture_subprocess_io do
      @logger.with_rescue_and_duration_event("foo", "bar", "baz") do
        nil
      end
    end
    event_start_log, event_finish_log = stdout[0].split("\n").map{|log| JSON.parse(log)}

    assert_equal "foo", event_start_log["correlation_id"]
    assert_equal "started", event_start_log["status"]
    assert_equal "bar", event_start_log["event"]
    assert_equal "baz", event_start_log["payload"]

    assert_equal "foo", event_finish_log["correlation_id"]
    assert_equal "finished", event_finish_log["status"]
    assert_equal "bar", event_finish_log["event"]
  end

  def test_with_rescue_and_duration_event_failed
    stdout = capture_subprocess_io do
      @logger.with_rescue_and_duration_event("foo", "bar", "baz") do
        raise
      end
    end

    event_start_log, event_error_log = stdout[0].split("\n").map{|log| JSON.parse(log)}

    assert_equal "foo", event_start_log["correlation_id"]
    assert_equal "started", event_start_log["status"]
    assert_equal "bar", event_start_log["event"]
    assert_equal "baz", event_start_log["payload"]

    assert_equal "foo", event_error_log["correlation_id"]
    assert_equal "failed", event_error_log["status"]
    assert_equal "bar", event_error_log["event"]
    assert_equal "RuntimeError", event_error_log["error_name"]
  end

  def test_with_rescue_and_duration_controller_finished
    stdout = capture_subprocess_io do
      @logger.with_rescue_and_duration_controller("foo", "bar", @mock_request) do
        nil
      end
    end

    controller_start_log, controller_finish_log = stdout[0].split("\n").map{|log| JSON.parse(log)}

    assert_equal "foo", controller_start_log["correlation_id"]
    assert_equal "started", controller_start_log["status"]
    assert_equal "bar", controller_start_log["path"]
    assert_equal "baz", controller_start_log["params"]

    assert_equal "foo", controller_finish_log["correlation_id"]
    assert_equal "finished", controller_finish_log["status"]
    assert_equal "bar", controller_finish_log["path"]
  end

  def test_with_rescue_and_duration_controller_failed
    stdout = capture_subprocess_io do
      @logger.with_rescue_and_duration_controller("foo", "bar", @mock_request) do
        raise
      end
    end

    controller_start_log, controller_error_log = stdout[0].split("\n").map{|log| JSON.parse(log)}

    assert_equal "foo", controller_start_log["correlation_id"]
    assert_equal "started", controller_start_log["status"]
    assert_equal "bar", controller_start_log["path"]
    assert_equal "baz", controller_start_log["params"]

    assert_equal "foo", controller_error_log["correlation_id"]
    assert_equal "failed", controller_error_log["status"]
    assert_equal "bar", controller_error_log["path"]
    assert_equal "RuntimeError", controller_error_log["error_name"]
  end

  def test_with_rescue_and_duration_command_finished
    stdout = capture_subprocess_io do
      @logger.with_rescue_and_duration_command("foo", "bar", "baz") do
        nil
      end
    end

    command_start_log, command_finish_log = stdout[0].split("\n").map{|log| JSON.parse(log)}

    assert_equal "foo", command_start_log["correlation_id"]
    assert_equal "started", command_start_log["status"]
    assert_equal "bar", command_start_log["command"]
    assert_equal "baz", command_start_log["args"]

    assert_equal "foo", command_finish_log["correlation_id"]
    assert_equal "finished", command_finish_log["status"]
    assert_equal "bar", command_finish_log["command"]
  end

  def test_with_rescue_and_duration_command_failed
    stdout = capture_subprocess_io do
      @logger.with_rescue_and_duration_command("foo", "bar", "baz") do
        raise
      end
    end

    command_start_log, command_error_log = stdout[0].split("\n").map{|log| JSON.parse(log)}

    assert_equal "foo", command_start_log["correlation_id"]
    assert_equal "started", command_start_log["status"]
    assert_equal "bar", command_start_log["command"]
    assert_equal "baz", command_start_log["args"]

    assert_equal "foo", command_error_log["correlation_id"]
    assert_equal "failed", command_error_log["status"]
    assert_equal "bar", command_error_log["command"]
    assert_equal "RuntimeError", command_error_log["error_name"]
  end

  def test_with_rescue_and_duration_worker_finished
    stdout = capture_subprocess_io do
      @logger.with_rescue_and_duration_worker("foo", "bar", "baz","foo") do
        nil
      end
    end

    worker_start_log, worker_finish_log = stdout[0].split("\n").map{|log| JSON.parse(log)}

    assert_equal "foo", worker_start_log["correlation_id"]
    assert_equal "started", worker_start_log["status"]
    assert_equal "bar", worker_start_log["worker"]
    assert_equal "baz", worker_start_log["args"]
    assert_equal "foo", worker_start_log["jid"]

    assert_equal "foo", worker_finish_log["correlation_id"]
    assert_equal "finished", worker_finish_log["status"]
    assert_equal "bar", worker_finish_log["worker"]
  end

  def test_with_rescue_and_duration_worker_failed
    stdout = capture_subprocess_io do
      @logger.with_rescue_and_duration_worker("foo", "bar", "baz", "foo") do
        raise
      end
    end
    
    worker_start_log, worker_error_log = stdout[0].split("\n").map{|log| JSON.parse(log)}

    assert_equal "foo", worker_start_log["correlation_id"]
    assert_equal "started", worker_start_log["status"]
    assert_equal "bar", worker_start_log["worker"]
    assert_equal "baz", worker_start_log["args"]
    assert_equal "foo", worker_start_log["jid"]

    assert_equal "foo", worker_error_log["correlation_id"]
    assert_equal "failed", worker_error_log["status"]
    assert_equal "bar", worker_error_log["worker"]
    assert_equal "RuntimeError", worker_error_log["error_name"]
  end

  def test_mask_message
    message = @logger.send(:mask_message, "200,000.00บ")
    assert_equal "xบ", message

    message = @logger.send(:mask_message, {message: "200,000บ"})
    assert_equal({"message" => "xบ"}, message)

    message = @logger.send(:mask_message, {"message" => "200,000บ"})
    assert_equal({"message" => "xบ"}, message)
  end
end
