using HevSCGI;

namespace HevSCGIHandlerModule
{
	public bool init(Handler self)
	{
		return true;
	}

	public void finalize(Handler self)
	{
	}

	public char * get_name(Handler self)
	{
		return "HevSCGIHandlerVala";
	}

	public char * get_version(Handler self)
	{
		return "0.0.1";
	}

	public char * get_pattern(Handler self)
	{
		return ".*";
	}

	private async void write_message(OutputStream output_stream)
	{
		Response response = output_stream.get_data("response");
		Task task = response.get_data("task");
		Handler self = task.get_handler();
		Request request = task.get_request();
		HashTable<string, string> hash_table = request.get_header_hash_table();
		string message = null;

		message = "<strong>Handler:</strong> " + self.get_name() + " " + self.get_version();
		message += "<br /><strong>RequestURI:</strong> " + hash_table.lookup("REQUEST_URI");
		message += "<br /><strong>RemoteAddr:</strong> " + hash_table.lookup("REMOTE_ADDR");
		message += "<br /><strong>RemotePort:</strong> " + hash_table.lookup("REMOTE_PORT");

		yield output_stream.write_async(message.data, Priority.DEFAULT);

		output_stream.set_data("response", null);
		response.set_data("task", null);
	}

	private void write_header_handler(void *data)
	{
		Response response = (Response)data;

		OutputStream output_stream = response.get_output_stream();

		output_stream.set_data("response", response);
		write_message.begin(output_stream);
	}

	public void handle(Handler self, Task task)
	{
		Response response = task.get_response();
		HashTable<string, string> hash_table = response.get_header_hash_table();

		hash_table.insert("Status", "200 OK");
		hash_table.insert("Content-Type", "text/html");

		response.set_data("task", task);
		response.write_header(write_header_handler);
	}
}

