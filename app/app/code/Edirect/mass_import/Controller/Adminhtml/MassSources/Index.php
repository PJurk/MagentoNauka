<?php 

namespace Edirect\MassSources\Controller\Adminhtml\MassSources;

use \Magento\Framework\Controller\ResultFactory;

class Index extends \Edirect\MassSources\Controller\Adminhtml\MassSource
{
  public function execute()
  {
    $resultPage = $this->resultFactory->create(ResultFactory::TYPE_PAGE);
    $resultPage->getConfig()->getTitle()->prepend((__('Mass Sources')));
    return $resultPage;
  }
}