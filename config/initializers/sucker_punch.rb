SuckerPunch.config do
  queue name: :extract_queue,    worker: ExtractWorker,    workers: 10
  queue name: :processing_queue, worker: ProcessingWorker, workers: 3
  queue name: :deactivate_queue, worker: DeactivateWorker, workers: 5
end