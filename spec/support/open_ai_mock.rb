def open_ai_mock
  {
    'status' => 'requires_action',
    'required_action' => {
      'submit_tool_outputs' => {
        'tool_calls' => [
          {
            'function' => {
              'name' => 'list_tasks',
              'arguments' => {
                'developer_tasks' => [
                  { 'name' => 'developer task 1' },
                  { 'name' => 'developer task 2' }
                ],
                'user_testing_tasks' => [
                  { 'name' => 'user testing task 1' },
                  { 'name' => 'user testing task 2' }
                ]
              }.to_json
            }
          }
        ]
      }
    }
  }
end

def open_ai_developer_tasks
  [
    { 'name' => 'developer task 1' },
    { 'name' => 'developer task 2' }
  ]
end

def open_ai_user_testing_tasks
  [
    { 'name' => 'user testing task 1' },
    { 'name' => 'user testing task 2' }
  ]
end
